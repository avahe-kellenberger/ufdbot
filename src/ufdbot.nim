import std/[asyncdispatch, httpclient, options, strutils, strformat, json, os, re]
import dimscord
import character

let botToken = getEnv("BOT_TOKEN")
if botToken.len == 0:
  quit "BOT_TOKEN env var must be provided!"

let discord = newDiscordClient(botToken)

let movesCommandRegex = re"!moves? .+"

# Handle event for on_ready.
proc onReady(s: Shard, r: Ready) {.event(discord).} =
    echo "Ready as " & $r.user

proc searchCharacterMove(characterName, moveName: string): Future[JsonNode] {.async.} =
  var client = newAsyncHttpClient()
  let content = await client.getContent(fmt"http://flatzone.pro:5000/characters/{characterName}/{moveName}")
  return parseJson(content)

template addProperty(property: Option[string], name: string) =
  ## Every 3 properties added, insert a new line.
  if property.isSome:
    if counter mod 3 == 0:
      result &= "\n"

    result &= "**" & name & "**: " & property.get()
    inc counter
    if counter mod 3 != 0:
      result &= "    "

proc formatReply(response: MoveLookupResponse): string =
  let move = response.move
  block:
    var counter = 0
    addProperty(move.startup, "Startup")
    addProperty(move.total_frames, "Total Frames")
    addProperty(move.active_frames, "Active On")
    addProperty(move.advantage, "On Shield")
    addProperty(move.landing_lag, "Landing Lag")
    addProperty(move.base_damage, "Base Damage")
    addProperty(move.shield_lag, "Shield Lag")
    addProperty(move.shield_stun, "Shield Stun")
    addProperty(move.which_hitbox, "Which Hitbox")
    addProperty(move.hops_autocancel, "Autocancels")
    addProperty(move.hops_actionable, "Actionable Before Landing")
    addProperty(move.endlag, "End Lag")
    addProperty(move.notes, "Notes")

proc getGifUrls(response: MoveLookupResponse): seq[string] =
  let move = response.move
  for hitbox in move.hitboxes:
    var url: string
    if hitbox.name.isSome:
      url &= hitbox.name.get() & "\n"
    url &= hitbox.url
    result.add(url)

proc sendFormattedReply(message: Message, response: MoveLookupResponse): Future[void] {.async.} =
  let title = fmt"**{response.character}: {response.move.move_name}**"
  discard await discord.api.sendMessage(message.channel_id, title)

  for gifUrl in getGifUrls(response):
    discard await discord.api.sendMessage(message.channel_id, gifUrl)

  discard await discord.api.sendMessage(message.channel_id, ">>> " & formatReply(response))

# Handle event for message_create.
proc messageCreate(s: Shard, message: Message) {.event(discord).} =
  if message.author.bot:
    return

  if message.content.match(movesCommandRegex):
    let split = message.content.split(" ")
    if split.len < 3:
      return

    let characterName = split[1]
    let moveName = split[2..^1].join()

    let response = await searchCharacterMove(characterName, moveName)
    if response.kind == JObject:
      let moveLookupResponse = response.to(MoveLookupResponse)
      await sendFormattedReply(message, moveLookupResponse)
    elif response.kind == JString:
      discard await discord.api.sendMessage(message.channel_id, response.str)
    else:
      discard await discord.api.sendMessage(message.channel_id, "Error: " & $response)

# Connect to Discord and run the bot.
waitFor discord.startSession()


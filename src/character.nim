import std/options

export options

type
  Hitbox* = object
    name*: Option[string]
    url*: string

  Move* = object
    hitboxes*: seq[Hitbox]
    move_name*: string
    startup*: Option[string]
    total_frames*: Option[string]
    landing_lag*: Option[string]
    notes*: Option[string]
    base_damage*: Option[string]
    shield_lag*: Option[string]
    shield_stun*: Option[string]
    which_hitbox*: Option[string]
    advantage*: Option[string]
    active_frames*: Option[string]
    hops_autocancel*:Option[string]
    hops_actionable*:Option[string]
    endlag*: Option[string]

  MoveLookupResponse* = object
    character*: string
    move*: Move


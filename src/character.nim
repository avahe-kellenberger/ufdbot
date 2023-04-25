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

  Stats* = object
    air_speed*: Option[string]
    fall_speed_fast_fall_speed*: Option[string]
    gravity*: Option[string]
    initial_dash*: Option[string]
    jump_squat*: Option[string]
    oos_options*: Option[seq[string]]
    run_speed*: Option[string]
    sh_fh_shff_fhff_frames*: Option[string]
    shield_drop*: Option[string]
    shield_grab*: Option[string]
    total_air_acceleration*: Option[string]
    walk_speed*: Option[string]
    weight*: Option[string]

  MoveLookupResponse* = object
    character*: string
    move*: Move

  StatsLookupResponse* = object
    character*: string
    stats*: Stats


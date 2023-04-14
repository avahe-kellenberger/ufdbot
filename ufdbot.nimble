# Package

version       = "0.1.0"
author        = "Avahe Kellenberger"
description   = "A new awesome nimble package"
license       = "GPL-2.0-only"
srcDir        = "src"
bin           = @["ufdbot"]


# Dependencies

requires "nim >= 1.6.12"
requires "dimscord >= 1.4.0"

task runr, "Runs the program":
  exec "nim r -d:ssl -d:release --opt:speed src/ufdbot.nim"

task release, "Creates a release build":
  exec "nim c -o:bin/ufd -d:ssl -d:release --opt:speed src/ufdbot.nim"


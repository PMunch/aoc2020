import sequtils, strutils

var valid = foldl(toSeq(lines("input.txt")).mapIt do:
  let
    split = it.split(": ")
    psplit = split[0].split(" ")
    esplit = psplit[0].split("-")
    start = esplit[0].parseInt
    stop = esplit[1].parseInt
    character = psplit[1][0]
    password = split[1]
  (password.count(character) in start..stop).int
, a + b)

echo valid

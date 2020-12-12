import math, strutils

type
  Direction = enum
    East = (0, "E"), South = (90, "S"),
    West = (180, "W"), North = (270, "N")

var
  wx = 10
  wy = -1
  x = 0
  y = 0

template whenHeading(character: char, body, otherwise: untyped): untyped =
  try:
    let heading {.inject.} = parseEnum[Direction]($character)
    body
  except:
    otherwise

for line in lines("input.txt"):
  let num = parseInt(line[1..^1])
  whenHeading(line[0]):
    case heading:
    of East: wx += num
    of West: wx -= num
    of South: wy += num
    of North: wy -= num
  do:
    case line[0]:
    of 'F':
      x += num * wx
      y += num * wy
    of 'R', 'L':
      if num == 180:
        wx *= -1
        wy *= -1
      else:
        let
          direction = if line[0] == 'R': num else: (num + 180) mod 360
          tx = wx
        wx = wy
        wy = tx
        if direction == 90:
          wx *= -1
        if direction == 270:
          wy *= -1
    else: discard

echo abs(x) + abs(y)

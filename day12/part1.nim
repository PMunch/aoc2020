import math, strutils

type
  Direction = enum
    East = (0, "E"), South = (90, "S"),
    West = (180, "W"), North = (270, "N")

var
  x = 0
  y = 0
  heading = East

for line in lines("input.txt"):
  var currentHeading = heading

  try:
    currentHeading = parseEnum[Direction]($line[0])
  except:
    case line[0]:
    of 'L':
      heading = Direction((heading.int - parseInt(line[1..^1])).floorMod(360))
    of 'R':
      heading = Direction((heading.int + parseInt(line[1..^1])).floorMod(360))
    of 'F': discard
    else: discard

  if line[0] notin {'L', 'R'}:
    var speed = parseInt(line[1..^1])
    case currentHeading:
    of East: x += speed
    of West: x -= speed
    of South: y += speed
    of North: y -= speed

echo abs(x) + abs(y)

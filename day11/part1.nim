import sequtils, strutils

var
  seating = toSeq(lines("input.txt"))
  newSeating = seating
  changes = 1

template neighbourLoop(body: untyped): untyped =
  for yy in y-1..y+1:
    for xx in x-1..x+1:
      if yy == y and xx == x: continue
      if yy < 0 or yy > seating.high: continue
      if xx < 0 or xx > seating[0].high: continue
      let neighbour {.inject.} = seating[yy][xx]
      body

while changes != 0:
  changes = 0
  for y in 0..seating.high:
    for x in 0..seating[0].high:
      case seating[y][x]:
      of '.': continue
      of 'L':
        block neighbourCheck:
          neighbourLoop:
            if neighbour == '#': break neighbourCheck
          newSeating[y][x] = '#'
          inc changes
      of '#':
        var neighbours = 0
        neighbourLoop:
          if neighbour == '#':
            inc neighbours
        if neighbours >= 4:
          newSeating[y][x] = 'L'
          inc changes
      else: discard
  seating = newSeating

var occupied = 0
for line in seating:
  for seat in line:
    if seat == '#':
      inc occupied

echo occupied

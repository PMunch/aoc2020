import sequtils

var
  seating = toSeq(lines("input.txt"))
  newSeating = seating
  changes = 1

template check(seat: untyped): untyped =
  case seat:
  of '.': continue
  of 'L', '#':
    yield seat
    break
  else: continue

iterator seenSeats(seating: seq[string], x, y: int): char =
  for xx in countdown(x - 1, 0):
    check(seating[y][xx])
  for xx in countup(x + 1, seating[y].high):
    check(seating[y][xx])
  for yy in countdown(y - 1, 0):
    check(seating[yy][x])
  for yy in countup(y + 1, seating.high):
    check(seating[yy][x])
  for offset in 1..min(y, x):
    check(seating[y - offset][x - offset])
  for offset in 1..min(y, seating[0].high-x):
    check(seating[y - offset][x + offset])
  for offset in 1..min(seating.high-y, seating[0].high-x):
    check(seating[y + offset][x + offset])
  for offset in 1..min(seating.high-y, x):
    check(seating[y + offset][x - offset])

var loopCount = 0
while changes != 0:
  changes = 0
  for y in 0..seating.high:
    for x in 0..seating[0].high:
      case seating[y][x]:
      of '.': continue
      of 'L':
        block neighbourCheck:
          for neighbour in seating.seenSeats(x, y):
            if neighbour == '#': break neighbourCheck
          newSeating[y][x] = '#'
          inc changes
      of '#':
        var neighbours = 0
        for neighbour in seating.seenSeats(x, y):
          if neighbour == '#':
            inc neighbours
        if neighbours >= 5:
          newSeating[y][x] = 'L'
          inc changes
      else: discard
  seating = newSeating
  inc loopCount
  #if loopCount == 3: break
  echo "------------------"
  for line in seating:
    echo line

var occupied = 0
for line in seating:
  for seat in line:
    if seat == '#':
      inc occupied

echo occupied

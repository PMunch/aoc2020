import strutils, algorithm

var sides: seq[tuple[line: string, id: int]]
let data = readFile("test_input.txt")
for tile in data.split("\n\n"):
  let
    lines = tile.splitLines
    titleLine = lines[0]
  if titleLine.len != 0:
    let title = titleLine[5..^2].parseInt
    var
      top = lines[1]
      bottom = lines[^1]
    sides.add (line: top, id: title)
    sides.add (line: bottom, id: title)
    top.reverse
    bottom.reverse
    sides.add (line: top, id: title)
    sides.add (line: bottom, id: title)
    var
      left = ""
      right = ""
    for i in 0..9:
      left.add lines[i+1][0]
      right.add lines[i+1][9]
    sides.add (line: left, id: title)
    sides.add (line: right, id: title)
    left.reverse
    right.reverse
    sides.add (line: left, id: title)
    sides.add (line: right, id: title)

sides.sort

#for t in test:
#  echo t, if t.id == 2311: " <-" else: ""

import tables

var
  i = 0
  nearby: Table[int, set[uint16]]

while i < sides.high:
  if sides[i+1].line == sides[i].line:
    nearby.mgetOrPut(sides[i+1].id, {}).incl sides[i].id.uint16
    nearby.mgetOrPut(sides[i].id, {}).incl sides[i+1].id.uint16
    inc i
  inc i

var sum = 1
for key, value in nearby:
  if value.card == 2:
    sum *= key

#echo nearby
echo sum


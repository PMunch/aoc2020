import strutils, algorithm, sequtils

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

import tables, math

var
  i = 0
  nearby: Table[int, set[uint16]]

while i < sides.high:
  if sides[i+1].line == sides[i].line:
    nearby.mgetOrPut(sides[i+1].id, {}).incl sides[i].id.uint16
    nearby.mgetOrPut(sides[i].id, {}).incl sides[i+1].id.uint16
    inc i
  inc i

var start: int
for key, value in nearby:
  if value.card == 2:
    start = key
    break

let size = nearby.len.float.sqrt.int
var image = newSeqWith(size, newSeq[int](size))
image[0][0] = start
var used = {image[0][0]}
for i in 1..(size-2):
  for neighbour in nearby[image[0][i-1]]:
    if neighbour notin used and nearby[neighbour.int].card == 3:
      image[0][i] = neighbour.int
      used.incl neighbour
      break

for neighbour in nearby[image[0][size - 2]]:
  if nearby[neighbour.int].card == 2:
    image[0][size - 1] = neighbour.int
    used.incl neighbour

for i in 1..(size-2):
  for neighbour in nearby[image[i-1][0]]:
    if neighbour notin used and nearby[neighbour.int].card == 3:
      image[i][0] = neighbour.int
      used.incl neighbour
      break

for neighbour in nearby[image[size - 2][0]]:
  if nearby[neighbour.int].card == 2:
    image[size - 1][0] = neighbour.int
    used.incl neighbour

for y in 1..(size-2):
  for x in 1..(size-2):
    for neighbour in nearby[image[y][x-1]] * nearby[image[y-1][x]]:
      if neighbour notin used and nearby[neighbour.int].card == 4:
        image[y][x] = neighbour.int
        used.incl neighbour

for y in 1..(size-2):
  for neighbour in nearby[image[y][size-2]] * nearby[image[y-1][size-1]]:
    if neighbour notin used and nearby[neighbour.int].card == 3:
      image[y][size-1] = neighbour.int
      used.incl neighbour

for x in 1..(size-2):
  for neighbour in nearby[image[size-2][x]] * nearby[image[size-1][x-1]]:
    if neighbour notin used and nearby[neighbour.int].card == 3:
      image[size-1][x] = neighbour.int
      used.incl neighbour

for neighbour in nearby[image[size-2][size-1]] * nearby[image[size-1][size-2]]:
  if neighbour notin used:
    image[size-1][size-1] = neighbour.int
    used.incl neighbour

# This is incomplete, the image doesn't have any rotation or flip data..
echo image
echo start


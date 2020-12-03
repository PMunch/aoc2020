import sequtils

var trees = toSeq(lines("input.txt"))

proc calculateSlope(right, down: int): int =
  var
    height = 0
    pos = 0
  while height + down < trees.len:
    height += down
    let line = trees[height]
    pos = (pos + right) mod line.len
    if line[pos] == '#':
      inc result

echo calculateSlope(1, 1) *
     calculateSlope(3, 1) *
     calculateSlope(5, 1) *
     calculateSlope(7, 1) *
     calculateSlope(1, 2)
#echo calculateSlope(1, 1)
#echo calculateSlope(3, 1)
#echo calculateSlope(5, 1)
#echo calculateSlope(7, 1)
#echo calculateSlope(1, 2)

var
  trees: array[323, uint32]
  i = 0
for line in lines("input.txt"):
  trees[i] = 0
  for j, c in line:
    if c == '#': trees[i] = trees[i] or (1'u32 shl j)
  inc i

#writeFile("input.hex", cast[array[323*4, byte]](trees))

#var
#  trees: array[323, uint32]
#  input = open("input.hex")
#discard readBuffer(input, trees.addr, trees.len*4)
#close(input)

proc calculateSlope(right, down: int): int =
  var
    height = 0
    pos = 0
  while height < trees.len:
    let line = trees[height]
    result += (line.int and (1 shl pos)) shr pos
    pos = (pos + right) mod 31
    height += down

#echo calculateSlope(3, 1)

echo calculateSlope(1, 1) *
     calculateSlope(3, 1) *
     calculateSlope(5, 1) *
     calculateSlope(7, 1) *
     calculateSlope(1, 2)

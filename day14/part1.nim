import tables, strutils

var
  mask: int
  maskBits: int
  memory: Table[int, int]

for line in lines("input.txt"):
  if line.startsWith("mask = "):
    reset mask
    reset maskBits
    for c in line[7..^1]:
      mask = mask shl 1
      maskBits = maskBits shl 1
      case c:
      of '1':
        mask = mask or 1
      of 'X':
        maskBits = maskBits or 1
      else: discard
  else:
    let
      address = parseInt(line[4..<line.find(']')])
      value = parseInt(line[line.find("= ")+2..^1])

    memory[address] = (value and maskBits) or mask

var total = 0
for value in memory.values:
  total += value

echo total





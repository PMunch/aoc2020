import tables, strutils, math

var
  mask: int
  maskBits: int
  maskBitsCount: int
  memory: Table[int, int]

for line in lines("input.txt"):
  if line.startsWith("mask = "):
    reset mask
    reset maskBits
    reset maskBitsCount
    for c in line[7..^1]:
      mask = mask shl 1
      maskBits = maskBits shl 1
      case c:
      of '1':
        mask = mask or 1
      of 'X':
        maskBits = maskBits or 1
        inc maskBitsCount
      else: discard
  else:
    let
      address = parseInt(line[4..<line.find(']')])
      value = parseInt(line[line.find("= ")+2..^1])

    for i in 0..(2.pow(maskBitsCount.float).int):
      var
        modifiedAddress = address or mask
        maskBitsShifter = maskBits
        j = 0
        counter = 0
      while maskBitsShifter != 0:
        if (maskBitsShifter and 1) != 0:
          modifiedAddress = modifiedAddress and (not (1 shl j))
          modifiedAddress = modifiedAddress or (((i and (1 shl counter)) shr counter) shl j)
          inc counter
        inc j
        maskBitsShifter = maskBitsShifter shr 1
      memory[modifiedAddress] = value

var total = 0
for value in memory.values:
  total += value

echo total

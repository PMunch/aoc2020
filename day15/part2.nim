import tables, strutils, sequtils

var
  startingNumbers = readFile("input.txt")[0..^2].split(',').map(parseInt)
  lastSeen: Table[int, int]

for i, number in startingNumbers[0..^2]:
  lastSeen[number] = i + 1

var lastNumber = startingNumbers[^1]

for i in (startingNumbers.len + 1)..30_000_000:
  var number = lastNumber
  if lastSeen.hasKey(number):
    number = i - 1 - lastSeen[number]
  else:
    number = 0
  lastSeen[lastNumber] = i - 1
  lastNumber = number

echo lastNumber

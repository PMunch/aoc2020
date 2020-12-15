import tables, strutils, sequtils

var
  #startingNumbers = readFile("input.txt").split(',').map(parseInt)
  startingNumbers = "14,3,1,0,9,5".split(',').map(parseInt)
  lastSeen: Table[int, int]

for i, number in startingNumbers[0..^2]:
  lastSeen[number] = i + 1

var lastNumber = startingNumbers[^1]

for i in (startingNumbers.len + 1)..2020:
  var number = lastNumber
  if lastSeen.hasKey(number):
    number = i - 1 - lastSeen[number]
  else:
    number = 0
  lastSeen[lastNumber] = i - 1
  lastNumber = number

echo lastNumber

import sequtils, strutils

var input = readFile("input.txt").split("\n\n").mapIt(it.split("\n"))

var total = 0
for group in input:
  var answerSet: set[char]
  for passenger in group:
    for question in passenger:
      answerSet.incl question
  total += answerSet.card

echo total

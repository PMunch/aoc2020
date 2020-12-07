import sequtils, strutils

var
  data = readFile("input.txt")
  input = data.split("\n\n").mapIt(it.split("\n"))

var total = 0
for group in input:
  var answerSet = {'a'..'z'}
  for passenger in group:
    if passenger != "":
      var passengerSet: set[char]
      for question in passenger:
        passengerSet.incl question
      answerSet = answerSet * passengerSet
  total += answerSet.card

echo total

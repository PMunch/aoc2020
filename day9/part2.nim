import sequtils, strutils

var numbers = toSeq(lines("input.txt")).map(parseInt)

const preamble = 25

var weakness: int

block findWeakness:
  for i in preamble..numbers.high:
    block numberCheck:
      for left in (i-preamble)..(i-2):
        for right in (left+1)..<i:
          if numbers[left] + numbers[right] == numbers[i]:
            break numberCheck
      weakness = numbers[i]
      break findWeakness

for start in 0..numbers.high:
  var sum = numbers[start]
  for stop in (start+1)..numbers.high:
    sum += numbers[stop]
    if sum > weakness:
      break
    if sum == weakness:
      var
        largest = 0
        smallest = int.high
      for i in start..stop:
        smallest = min(numbers[i], smallest)
        largest = max(numbers[i], largest)
      echo smallest + largest
      quit 0

import sequtils, strutils

var numbers = toSeq(lines("input.txt")).mapIt(it.parseInt)

const preamble = 25

for i in preamble..numbers.high:
  block numberCheck:
    for left in (i-preamble)..(i-2):
      for right in (left+1)..<i:
        if numbers[left] + numbers[right] == numbers[i]:
          break numberCheck
    echo numbers[i]

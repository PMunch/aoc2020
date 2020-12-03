import strutils, sequtils, algorithm

var numbers = toSeq(lines("input.txt")).map(parseInt)
numbers.sort

for i, one in numbers:
  for ii, two in numbers[i+1..^1]:
    let psum = one + two
    if psum >= 2020: break
    for three in numbers[ii+1..^1]:
      if psum + three > 2020: break
      if psum + three == 2020:
        echo one * two * three
        #assert 68348924 == one * two * three
        quit 0

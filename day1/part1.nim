import strutils

for left in lines("input.txt"):
  for right in lines("input.txt"):
    if left != right:
      let
        nLeft = parseInt(left)
        nRight = parseInt(right)
      if nLeft + nRight == 2020:
        echo nLeft * nRight
        quit 0

import strutils, sequtils, algorithm

var adapters = toSeq(lines("input.txt")).map(parseInt)

adapters.sort

var
  nums = [0, 0, 0, 1]
  last = 0

for adapter in adapters:
  let diff = adapter - last
  inc nums[diff]
  last = adapter

echo nums[1] * nums[3]

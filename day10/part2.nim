import strutils, sequtils, algorithm
import tables

var adapters = toSeq(lines("input.txt")).map(parseInt).sorted
#var adapters = "1, 4, 5, 6, 7, 10, 11, 12, 15, 16, 19".split(", ").map(parseInt).sorted
var waysToReach = [0].toCountTable # Ways to start at 0 is always 1

adapters.add adapters[^1] + 3

for adapter in adapters:
  # Set the numbers of unique ways to reach this adapter to the sum of unique ways to reach all adapters that can get here
  waysToReach[adapter] = waysToReach[adapter - 3] +
                         waysToReach[adapter - 2] +
                         waysToReach[adapter - 1]

echo waysToReach[adapters[^1]] # Since the end voltage is always exactly three above the highest adapter there is only one way to end

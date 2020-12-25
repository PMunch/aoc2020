import lists

#let data = "389125467"
let data = readFile("input.txt")[0..^2]

var
  ring = initSinglyLinkedRing[int]()
  minCup = int.high
  maxCup = 0

for c in data:
  let cup = ord(c) - ord('0')
  ring.append(cup)
  minCup = min(minCup, cup)
  maxCup = max(maxCup, cup)

var currentCup = ring.head
for round in 1..100:
  var takenCups = currentCup.next
  currentCup.next = currentCup.next.next.next.next

  var wantCup = currentCup.value - 1

  while not ring.contains(wantCup):
    dec wantCup
    if wantCup < minCup:
      wantCup = maxCup

  var destination = ring.find(wantCup)

  takenCups.next.next.next = destination.next
  destination.next = takenCups

  currentCup = currentCup.next
  ring.head = currentCup

  echo round, " - ", wantCup
  echo ring

currentCup = ring.find(1).next
var order = ""
while currentCup.value != 1:
  order &= $currentCup.value
  currentCup = currentCup.next

echo order

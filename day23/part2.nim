import lists, tables

#let data = "389125467"
let data = readFile("input.txt")[0..^2]

var
  ring = initSinglyLinkedRing[int]()
  nodes: Table[int, SinglyLinkedNode[int]]
  minCup = int.high
  maxCup = 0

for c in data:
  let cup = ord(c) - ord('0')
  nodes[cup] = newSinglyLinkedNode(cup)
  ring.append(nodes[cup])
  minCup = min(minCup, cup)
  maxCup = max(maxCup, cup)

for val in (maxCup + 1)..1_000_000:
  nodes[val] = newSinglyLinkedNode(val)
  ring.append(nodes[val])
maxCup = 1_000_000

var currentCup = ring.head
for round in 1..10_000_000:
  var takenCups = currentCup.next
  currentCup.next = currentCup.next.next.next.next

  var wantCup = currentCup.value - 1
  if wantCup < minCup:
    wantCup = maxCup

  while takenCups.value == wantCup or
        takenCups.next.value == wantCup or
        takenCups.next.next.value == wantCup:
    dec wantCup
    if wantCup < minCup:
      wantCup = maxCup

  var destination = nodes[wantCup]

  takenCups.next.next.next = destination.next
  destination.next = takenCups

  currentCup = currentCup.next
  ring.head = currentCup

currentCup = ring.find(1).next
let
  a = currentCup.value
  b = currentCup.next.value

echo a
echo b
echo a * b

import deques, strutils, sequtils

let data = readFile("input.txt")

var
  player1: Deque[int]
  player2: Deque[int]

var currentPlayer: Deque[int]
for deck in data.split("\n\n"):
  for line in deck.splitLines:
    if line.len > 0 and line[0] != 'P':
      currentPlayer.addLast(parseInt(line))
  if player1.len == 0:
    player1 = currentPlayer
    reset currentPlayer
  else:
    player2 = currentPlayer

while player1.len > 0 and player2.len > 0:
  if player1.peekFirst > player2.peekFirst:
    player1.addLast player1.popFirst
    player1.addLast player2.popFirst
  else:
    player2.addLast player2.popFirst
    player2.addLast player1.popFirst

var
  score = 0
  winner = if player1.len != 0: player1 else: player2
  counter = 1

while winner.len > 0:
  score += winner.popLast * counter
  inc counter

echo score

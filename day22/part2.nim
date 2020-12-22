import deques, strutils, hashes, sets

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

proc `[]`(deque: Deque[int], r: Slice[int]): Deque[int] =
  for i in r:
    result.addLast(deque[i])

proc hash(player1, player2: Deque[int]): Hash =
  var
    p1h: Hash = 0
    p2h: Hash = 0
  for value in player1:
    p1h = p1h !& hash(value)
  for value in player2:
    p2h = p2h !& hash(value)
  result = p1h !& p2h
  return !$result

proc playGame(player1, player2: var Deque[int]): bool =
  var seenGames: HashSet[Hash]

  while player1.len > 0 and player2.len > 0:
    var stateHash = hash(player1, player2)
    if stateHash in seenGames:
      return true
    elif player1.peekFirst < player1.len and player2.peekFirst < player2.len:
      var
        player1Sub = player1[1..player1.peekFirst]
        player2Sub = player2[1..player2.peekFirst]
      result = playGame(player1Sub, player2Sub)
    else:
      if player1.peekFirst > player2.peekFirst:
        result = true
      else:
        result = false
    seenGames.incl stateHash
    if result:
      player1.addLast player1.popFirst
      player1.addLast player2.popFirst
    else:
      player2.addLast player2.popFirst
      player2.addLast player1.popFirst

var
  score = 0
  winner = if playGame(player1, player2): player1 else: player2
  counter = 1

while winner.len > 0:
  score += winner.popLast * counter
  inc counter

echo score

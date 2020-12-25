import tables

var tiles: CountTable[tuple[x: int, y: int]]

for line in lines("input.txt"):
  var
    pos = 0
    x = 0
    y = 0
  while pos < line.len:
    case line[pos]:
    of 's':
      inc pos
      if y mod 2 != 0:
        if line[pos] == 'e':
          inc x
      elif line[pos] == 'w':
        dec x
      inc y
    of 'n':
      inc pos
      if y mod 2 != 0:
        if line[pos] == 'e':
          inc x
      elif line[pos] == 'w':
        dec x
      dec y
    of 'e':
      inc x
    of 'w':
      dec x
    else: discard
    inc pos
  tiles.inc (x, y)

var black = 0
for val in tiles.values:
  if val mod 2 != 0:
    inc black

echo black

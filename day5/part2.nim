var seats: seq[int]

for line in lines("input.txt"):
  var
    lrow = 0
    hrow = 127
    rowstep = 64
    lcol = 0
    hcol = 7
    colstep = 4
  for i, c in line:
    case c:
    of 'F': hrow -= rowstep
    of 'B': lrow += rowstep
    of 'L': hcol -= colstep
    of 'R': lcol += colstep
    else: discard
    if c in "FB":
      rowstep = rowstep div 2
    if c in "LR":
      colstep = colstep div 2
  assert hrow == lrow
  assert lcol == hcol
  let seatID = lrow * 8 + lcol
  seats.add seatID

import algorithm

seats.sort
var last = seats[0]-1
for seat in seats:
  if last+1 != seat:
    echo last + 1
  last = seat

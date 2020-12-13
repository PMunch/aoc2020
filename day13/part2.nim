import sequtils, strutils

let
  notes = toSeq(lines("input.txt"))
  buses = notes[1].split(',')

# Store buses we have to check as bus number and offset index
var deltaBuses: seq[tuple[index: int, bus: int]]
for i, bus in buses:
  if bus != "x":
    deltaBuses.add (i, parseInt(bus))

# Find where the two first buses first match
var start = 0
while true:
  if (start + deltaBuses[1].index) mod deltaBuses[0].bus == 0 and
     (start + deltaBuses[1].index) mod deltaBuses[1].bus == 0:
    break
  inc start

# Start looking for the third bus, at bus 1 * bus 2 increments. This is the
# increment at which these two buses will always be in the same position
var
  currentBus = 2
  stepDistance = deltaBuses[0].bus * deltaBuses[1].bus

# Loop through all the buses, increasing the step distance by the current bus
# every time we find an matching position. Only start looping from the current
# match.
while currentBus < deltaBuses.len:
  for i in countup(start, int.high, stepDistance):
    if (i + deltaBuses[currentBus].index) mod deltaBuses[currentBus].bus == 0:
      stepDistance *= deltaBuses[currentBus].bus
      inc currentBus
      start = i
      break

# The position we would start looking for the next bus on when there are no
# more buses is the position in which all the buses match their schedules.
echo start

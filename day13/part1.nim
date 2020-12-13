import sequtils, strutils

let
  notes = toSeq(lines("input.txt"))
  earliestDeparture = notes[0].parseInt
  buses = notes[1].split(',').filterIt(it != "x").map(parseInt)

var
  earliestBus = int.high
  busId: int

for bus in buses:
  var departure = 0
  while departure < earliestDeparture:
    departure += bus
  if departure < earliestBus:
    busId = bus
    earliestBus = departure

echo (earliestBus - earliestDeparture) * busId

import npeg, strutils, sequtils, tables

var
  rules: Table[string, set[uint16]]
  myTicket: seq[uint16]
  tickets: seq[seq[uint16]]

let parser = peg "notes":
  notes <- rules * "\n" * myTicket * "\n" * otherTickets * !1
  rules <- +(rule * "\n")
  rule <- >+{'a'..'z', ' '} * ": " * range * " or " * range:
    rules[$1] = rules[""]
    rules.del ""
  range <- >+Digit * "-" * >+Digit:
    if rules.len == 0 or not rules.hasKey(""):
      rules[""] = {parseInt($1).uint16..parseInt($2).uint16}
    else:
      rules[""] = rules[""] + {parseInt($1).uint16..parseInt($2).uint16}
  myTicket <- "your ticket:\n" * ticket:
    myTicket = tickets.pop
  otherTickets <- "nearby tickets:\n" * *(ticket)
  ticket <- *(>+Digit * ",") * >+Digit * "\n":
    tickets.add capture[1..^1].mapIt(it.s.parseInt.uint16)

echo parser.matchFile("input.txt")

var superRule: set[uint16]
for rule in rules.values:
  superRule = superRule + rule

var validTickets: seq[seq[uint16]]
for ticket in tickets:
  block checkTicket:
    for number in ticket:
      if number notin superRule:
        break checkTicket
    validTickets.add ticket

var possibleFields = newSeqWith(myTicket.len, toSeq(rules.keys))
for i in 0..myTicket.high:
  for ticket in validTickets:
    possibleFields[i].keepItIf do:
      ticket[i] in rules[it]

var singles: seq[string]

while singles.len != myTicket.len:
  for fields in possibleFields.mitems:
    if fields.len == 1:
      if fields[0] notin singles:
        singles.add fields[0]
    else:
      fields.keepItIf do:
        it notin singles

var sum = 1
for i, fields in possibleFields:
  if fields[0].startsWith("departure"):
    sum *= myTicket[i].int

echo sum

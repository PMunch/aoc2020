import npeg, strutils, sequtils

var
  rules: seq[tuple[name: string, valid: set[uint16]]]
  myTicket: seq[uint16]
  tickets: seq[seq[uint16]]

let parser = peg "notes":
  notes <- rules * "\n" * myTicket * "\n" * otherTickets * !1
  rules <- +(rule * "\n")
  rule <- >+{'a'..'z', ' '} * ": " * range * " or " * range:
    rules[^1].name = $1
  range <- >+Digit * "-" * >+Digit:
    if rules.len == 0 or rules[^1].name.len > 0:
      rules.add (name: "", valid: {parseInt($1).uint16..parseInt($2).uint16})
    else:
      rules[^1].valid =
        rules[^1].valid + {parseInt($1).uint16..parseInt($2).uint16}
  myTicket <- "your ticket:\n" * ticket:
    myTicket = tickets.pop
  otherTickets <- "nearby tickets:\n" * *(ticket)
  ticket <- *(>+Digit * ",") * >+Digit * "\n":
    tickets.add capture[1..^1].mapIt(it.s.parseInt.uint16)

echo parser.matchFile("input.txt")

var superRule: set[uint16]
for rule in rules:
  superRule = superRule + rule.valid

var errorRate = 0
for ticket in tickets:
  for number in ticket:
    if number notin superRule:
      errorRate += number.int

echo errorRate

import npeg, tables, strutils

type
  Rule = object
    count: int
    colour: string
  Rules = Table[string, seq[Rule]]
  ParseState = object
    rules: Rules
    currentRules: seq[Rule]

let parser = peg("rules", r: ParseState):
  rules <- +rule
  rule <- >identifier * " bags contain " * *restrictions * "\n":
    r.rules[$1] = r.currentRules
    reset r.currentRules
  restrictions <- "no other bags." | (restriction * *(", " * restriction) * ".")
  restriction <- >number * " " * >identifier * (" bags" | " bag"):
    r.currentRules.add Rule(count: parseInt($1), colour: $2)
  identifier <- *{'a'..'z'} * " " * *{'a'..'z'}
  number <- {'1'..'9'}

var rules: ParseState
if not parser.match(readFile("input.txt"), rules).ok:
  quit 1

proc countBags(bag: string): int =
  result = 1
  for bag in rules.rules[bag]:
    result += bag.count * countBags(bag.colour)

echo countBags("shiny gold") - 1

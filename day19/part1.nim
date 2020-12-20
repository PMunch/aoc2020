import npeg, strutils, sequtils, tables, streams

type
  Index = int
  RuleKind = enum Leaf, List, Choice
  Rule = object
    case kind: RuleKind
    of Leaf:
      character: char
    of List:
      rules: seq[Index]
    of Choice:
      a: seq[Index]
      b: seq[Index]

var
  currentRule: Rule
  parsedRules: Table[Index, Rule]
  parsedMessages: seq[string]

let parser = peg "input":
  input <- +rule * "\n" * +message
  rule <- >+Digit * ": " * (character | choice | list) * "\n":
    parsedRules[parseInt($1)] = currentRule
    reset currentRule
  character <- '"' * >Alpha * '"':
    currentRule = Rule(kind: Leaf, character: capture[1].s[0])
  list <- numberList * +Digit:
    currentRule = Rule(kind: List, rules: capture[0].s.split.map(parseInt))
  choice <- >numberList * "| " * >(numberList * +Digit):
    currentRule = Rule(kind: Choice,
      a: capture[1].s.split.filterIt(it.len != 0).map(parseInt),
      b: capture[2].s.split.map(parseInt))
  numberList <- *(+Digit * " ")
  message <- >+Alpha * "\n":
    parsedMessages.add $1

discard parser.matchFile("test2_input.txt")

proc checkRule(x: Stream, ruleIdx: Index): bool =
  let rule = parsedRules[ruleIdx]
  case rule.kind:
  of Leaf:
    x.readChar == rule.character
  of List:
    for subRule in rule.rules:
      if not x.checkRule(subRule):
        return false
    return true
  of Choice:
    let oldPosition = x.getPosition
    for subRule in rule.a:
      if not x.checkRule(subRule):
        x.setPosition oldPosition
        break
    if oldPosition != x.getPosition:
      return true
    for subRule in rule.b:
      if not x.checkRule(subRule):
        return false
    return true

var valid = 0
for message in parsedMessages:
  var stream = newStringStream(message)
  if stream.checkRule(0) and stream.atEnd:
    inc valid

echo valid

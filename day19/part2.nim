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

discard parser.matchFile("input.txt")

proc checkRule(x: Stream, ruleIdx: Index, indent = 0): bool =
  let rule = parsedRules[ruleIdx]
  case rule.kind:
  of Leaf:
    result = x.readChar == rule.character
  of List:
    for subRule in rule.rules:
      if not x.checkRule(subRule, indent+1):
        return false
    return true
  of Choice:
    let oldPosition = x.getPosition
    for subRule in rule.a:
      if not x.checkRule(subRule, indent+1):
        x.setPosition oldPosition
        break
    var goodPosition: int
    if oldPosition != x.getPosition:
      result = true
      goodPosition = x.getPosition
    x.setPosition oldPosition
    for subRule in rule.b:
      if not x.checkRule(subRule, indent+1):
        if result == true:
          x.setPosition(goodPosition)
        return result
    if result == true and goodPosition < x.getPosition:
      x.setPosition goodPosition
    return true

var valid = 0
for message in parsedMessages:
  var stream = newStringStream(message)
  # Manually implement the logic of the changed rules
  var oldPosition = 0
  var
    r42 = 0
    r31 = 0
  while stream.checkRule(42):
    oldPosition = stream.getPosition
    inc r42
  stream.setPosition oldPosition
  oldPosition = 0
  while stream.checkRule(31):
    oldPosition = stream.getPosition
    inc r31
  if stream.atEnd and r42 > 0 and r31 > 0 and r42 > r31:
    inc valid

echo valid

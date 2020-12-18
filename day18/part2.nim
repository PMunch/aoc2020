import streams

type Op = enum None, Add, Mul

template doOp(valStmt: untyped): untyped =
  let val = valStmt
  case cOp:
  of None: result = val
  of Add: result += val
  of Mul:
    result *= awaitingMul
    awaitingMul = result
    result = val
  cOp = None

proc evaluate(x: Stream): int =
  var
    cOp = None
    awaitingMul = 1
  while not x.atEnd:
    let c = x.readChar
    case c:
    of '0'..'9': doOp(ord(c) - ord('0'))
    of '+': cOp = Add
    of '*': cOp = Mul
    of '(': doOp(evaluate(x))
    of ')': return result * awaitingMul
    else: discard
  result *= awaitingMul

var total = 0
for line in lines("input.txt"):
  total += evaluate newStringStream(line)

echo total

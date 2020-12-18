import streams

type Op = enum None, Add, Mul

template doOp(): untyped =
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
    of '0'..'9':
      let val = ord(c) - ord('0')
      doOp()
    of '+': cOp = Add
    of '*': cOp = Mul
    of '(':
      let val = evaluate(x)
      doOp()
    of ')': return result * awaitingMul
    else: discard
  result *= awaitingMul

var total = 0
for line in lines("input.txt"):
  total += evaluate newStringStream(line)

echo total

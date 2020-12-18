import streams

type Op = enum None, Add, Mul

template doOp(): untyped =
  case cOp:
  of None: result = val
  of Add: result += val
  of Mul: result *= val
  cOp = None

proc evaluate(x: Stream): int =
  var cOp = None
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
    of ')': return
    else: discard

var total = 0
for line in lines("input.txt"):
  total += evaluate newStringStream(line)

echo total

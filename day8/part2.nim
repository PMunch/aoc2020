import strutils, sequtils

var instructions = toSeq(lines("input.txt")).mapIt(it.split(" ")).mapIt((op: it[0], val: it[1].parseInt))

for i in 0..instructions.high:
  var modifiedInstructions = instructions
  case modifiedInstructions[i].op:
  of "acc": continue
  of "nop": modifiedInstructions[i].op = "jmp"
  of "jmp": modifiedInstructions[i].op = "nop"

  var
    accumulator = 0
    currentInstruction = 0'i16
    visitedInstructions: set[int16]

  while currentInstruction notin visitedInstructions:
    if currentInstruction == instructions.len:
      echo i
      echo accumulator
      quit 0
    visitedInstructions.incl currentInstruction
    let instruction = modifiedInstructions[currentInstruction]
    block runInstruction:
      case instruction.op:
      of "nop": discard
      of "acc": accumulator += instruction.val
      of "jmp":
        currentInstruction += instruction.val.int16
        break runInstruction
      inc currentInstruction

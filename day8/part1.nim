import strutils, sequtils

var instructions = toSeq(lines("input.txt"))

var
  accumulator = 0
  currentInstruction = 0'i16
  visitedInstructions: set[int16]

while currentInstruction notin visitedInstructions:
  visitedInstructions.incl currentInstruction
  let instruction = instructions[currentInstruction].split(" ")
  block runInstruction:
    case instruction[0]:
    of "nop": discard
    of "acc": accumulator += parseInt(instruction[1])
    of "jmp":
      currentInstruction += parseInt(instruction[1]).int16
      break runInstruction
    inc currentInstruction

echo accumulator

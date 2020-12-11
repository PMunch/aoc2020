import strutils, sequtils, tables, macros

var passports = readFile("input.txt").split("\n\n").mapIt(it.split).mapIt do:
  var keyTable: Table[string, string]
  for pair in it:
    if pair == "": continue
    let keyValue = pair.split(":")
    keyTable[keyValue[0]] = keyValue[1]
  keyTable

var valid = 0

macro assertAll(body: untyped): untyped =
  result = newStmtList()
  for stmt in body:
    result.add nnkCall.newTree(
      newIdentNode("doAssert"),
      stmt
    )

template withKey(keyStr: string, body: untyped): untyped =
  doAssert passport.hasKey(keyStr)
  block:
    let key {.inject.} =  passport[keyStr]
    assertAll(body)

for passport in passports:
  try:
    withKey("byr"):
      key.parseInt in 1920..2002
    withKey("iyr"):
      key.parseInt in 2010..2020
    withKey("eyr"):
      key.parseInt in 2020..2030
    withKey("hgt"):
      (key.endsWith("cm") and key[0..^3].parseInt in 150..193) or
      (key.endsWith("in") and key[0..^3].parseInt in 59..76)
    withKey("hcl"):
      key[0] == '#' and key.len == 7
      key[1..^1].parseHexInt >= 0 # Any condition, parsing throws the exception
    withKey("ecl"):
      key in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
    withKey("pid"):
      key.len == 9
      key.parseInt >= 0
    inc valid
  except: continue

echo valid

import strutils, sequtils, sets#, tables

var passports = readFile("input.txt").split("\n\n").mapIt(it.split).mapIt do:
  var keySet: HashSet[string]
  for pair in it:
    if pair == "": continue
    let keyValue = pair.split(":")
    keySet.incl keyValue[0]
  keySet

var
  valid = 0
  required = toHashSet(["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"])
for passport in passports:
  if passport.intersection(required) == required:
    inc valid

echo valid

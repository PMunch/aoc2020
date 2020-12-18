import sequtils, sets

let data = toSeq(lines("input.txt"))

var actives: HashSet[tuple[x: int, y: int, z: int]]

var
  maxX, maxY, maxZ = 0
  minX, minY, minZ = 0

for y, line in data:
  for x, c in line:
    if c == '#':
      actives.incl (x, y, 0)
      maxX = max(maxX, x)
      maxY = max(maxY, y)
      minX = min(minX, x)
      minY = min(minY, y)

proc `$`(inp: HashSet[tuple[x: int, y: int, z: int]]): string =
  for z in minZ..maxZ:
    result.add "z: " & $z & "\n"
    for y in minY..maxY:
      for x in minX..maxX:
        if (x, y, z) in inp:
          result.add "#"
        else:
          result.add "."
      result.add "\n"
    result.add "\n\n"



for i in 0..5:
  var oldActives = actives
  for z in (minZ-1)..(maxZ+1):
    for x in (minX-1)..(maxX+1):
      for y in (minY-1)..(maxY+1):
        var neighbours = 0
        for nz in (z-1)..(z+1):
          for nx in (x-1)..(x+1):
            for ny in (y-1)..(y+1):
              if (nx, ny, nz) != (x, y, z) and (nx, ny, nz) in oldActives:
                inc neighbours
        if (x, y, z) in oldActives and neighbours notin {2, 3}:
          actives.excl (x, y, z)
        if (x, y, z) notin oldActives and neighbours == 3:
          actives.incl (x, y, z)
  for active in actives:
    maxX = max(maxX, active.x)
    maxY = max(maxY, active.y)
    maxZ = max(maxZ, active.z)
    minX = min(minX, active.x)
    minY = min(minY, active.y)
    minZ = min(minZ, active.z)

echo actives.card


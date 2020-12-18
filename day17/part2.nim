import sequtils, sets

let data = toSeq(lines("input.txt"))

var actives: HashSet[tuple[x: int, y: int, z: int, w: int]]

var
  maxX, maxY, maxZ, maxW = 0
  minX, minY, minZ, minW = 0

for y, line in data:
  for x, c in line:
    if c == '#':
      actives.incl (x, y, 0, 0)
      maxX = max(maxX, x)
      maxY = max(maxY, y)
      minX = min(minX, x)
      minY = min(minY, y)

for i in 0..5:
  var oldActives = actives
  for z in (minZ-1)..(maxZ+1):
    for x in (minX-1)..(maxX+1):
      for y in (minY-1)..(maxY+1):
        for w in (minW-1)..(maxW+1):
          var neighbours = 0
          for nz in (z-1)..(z+1):
            for nx in (x-1)..(x+1):
              for ny in (y-1)..(y+1):
                for nw in (w-1)..(w+1):
                  if (nx, ny, nz, nw) != (x, y, z, w) and (nx, ny, nz, nw) in oldActives:
                    inc neighbours
          if (x, y, z, w) in oldActives and neighbours notin {2, 3}:
            actives.excl (x, y, z, w)
          if (x, y, z, w) notin oldActives and neighbours == 3:
            actives.incl (x, y, z, w)
  for active in actives:
    maxX = max(maxX, active.x)
    maxY = max(maxY, active.y)
    maxZ = max(maxZ, active.z)
    maxW = max(maxW, active.w)
    minX = min(minX, active.x)
    minY = min(minY, active.y)
    minZ = min(minZ, active.z)
    minW = min(minW, active.w)

echo actives.card


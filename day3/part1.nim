var
  pos = 0
  hitTrees = 0
  notFirst = false

for line in lines("input.txt"):
  if notFirst:
    pos = (pos + 3) mod line.len
    if line[pos] == '#':
      inc hitTrees
  notFirst = true

echo hitTrees

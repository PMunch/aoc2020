import npeg, tables, sets, sequtils

#let data = """mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
#trh fvjkl sbzzf mxmxvkd (contains dairy)
#sqjhc fvjkl (contains soy)
#sqjhc mxmxvkd sbzzf (contains fish)"""

let data = readFile("input.txt")

var
  ingredientsCount: CountTable[string]
  allIngredients: HashSet[string]
  allergens: Table[string, HashSet[string]]
  parsedIngredients: seq[string]
  parsedAllergens: seq[string]

template `+=`*(s1: var HashSet, s2: HashSet) =
  ## Alias for ``s1 = s1 + s2``
  s1 = s1 + s2

template `*=`*(s1: var HashSet, s2: HashSet) =
  ## Alias for ``s1 = s1 + s2``
  s1 = s1 * s2

var parser = peg "list":
  list <- +(line * ("\n" | !1))
  line <- ingredients * " " * allergens:
    for ingredient in parsedIngredients:
      ingredientsCount.inc(ingredient)
    var ingredientsSet = toHashSet(parsedIngredients)
    allIngredients += ingredientsSet
    for allergen in parsedAllergens:
      if allergens.hasKey(allergen):
        allergens[allergen] *= ingredientsSet
      else:
        allergens[allergen] = ingredientsSet
  ingredients <- >+Lower * *(' ' * >+Lower):
    parsedIngredients = capture[1..^1].mapIt(it.s)
  allergens <- "(contains " * >+Lower * *(", " * >+Lower) * ")":
    parsedAllergens = capture[1..^1].mapIt(it.s)

if parser.match(data).ok:
  #echo allergens
  #echo allIngredients
  var goodIngredients = allIngredients
  for allergen in allergens.values:
    goodIngredients = goodIngredients - allergen

  var count = 0
  for ingredient in goodIngredients:
    count += ingredientsCount[ingredient]

  echo count

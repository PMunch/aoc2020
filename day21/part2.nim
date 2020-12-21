import npeg, tables, sets, sequtils, strutils, algorithm

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

type Mapping = tuple[allergen, ingredient: string]

proc myCmp(a, b: Mapping): int =
  a.allergen.cmp b.allergen

if parser.match(data).ok:
  var
    allergenToIngredient: seq[Mapping]
    dangerous = initHashSet[string]()
  while dangerous.card != allergens.len:
    for allergen, ingredients in allergens:
      let unknown = ingredients - dangerous
      if unknown.card == 1:
        allergenToIngredient.add (allergen: allergen, ingredient: unknown.toSeq[0])
        dangerous += unknown
  echo allergenToIngredient.sorted(myCmp).mapIt(it.ingredient).join ","

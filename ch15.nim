import std/[strutils,sequtils,tables,deques,sets]
import utils/common

# Using the list words.txt as a list of valid words,
# find the shortest full chain of each word pair in the input.
# The answer is the product of the lengths of each chain.

const
  alphabet = "abcdefghijklmnopqrstuvwxyz"

type
  Task = tuple
    one, two: string

  Data = seq[Task]


func parseTask(line: string): Task =
  let words = line.split(",", 2)
  result = (words[0], words[1])


proc parseData: Data =
  readInput().strip.splitLines.map(parseTask)


proc getWords(filename: string): HashSet[string] =
  for word in lines(filename):
    result.incl(word)


iterator mutations(word: string): string =
  var mutant = word
  for i, c in word:
    for c in alphabet:
      mutant[i] = c
      yield mutant
    mutant[i] = c


iterator neighbors(dict: HashSet[string], word: string): string =
  for mutant in word.mutations:
    if mutant in dict:
      yield mutant


func getPath(parent: Table[string, string], this: string): seq[string] =
  var node = this
  while node in parent:
    result.add(node)
    node = parent[node]
  result.add(node)


proc findLadder(dict: HashSet[string], start, finish: string): seq[string] =
  var seen = [start].toHashSet
  var queue = [start].toDeque
  var parent: Table[string, string]
  while queue.len > 0:
    let this = queue.popFirst
    if this == finish:
      return parent.getPath(this)
    for next in dict.neighbors(this):
      if next notin seen:
        seen.incl(next)
        queue.addLast(next)
        parent[next] = this


let data = parseData()
let dict = getWords("data/words.txt")

benchmark:
  echo data.mapIt(dict.findLadder(it.one, it.two).len).prod

# 97920000

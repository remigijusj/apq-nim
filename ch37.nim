import std/[strutils,sequtils,intsets]
import utils/common

# Wordle solver
#
# At each guess, you mark down a 0 for a totally incorrect letter,
# a 1 for a correct letter in the wrong place,
# and a 2 for a correct letter in the correct place.
# Every time you identify a single answer word, you start a new set of guesses with a new, unknown answer.
# Correct answer is never written down. All answers are in the subset of five letter words.

type
  Score = range[0..2]

  Item = tuple
    guess: string
    score: seq[Score]

  Data = seq[Item]

  Dict = seq[string]


func parseItem(line: string): Item =
  assert line.len == 15 and line[5] == ','
  result.guess = line[0..<5]
  result.score = line[6..^1].split(' ').mapIt(it.parseInt.Score)


proc parseData: Data =
  readInput().strip.split('\n')[1..^1].map(parseItem)


proc getWords(filename: string, size: int): Dict =
  for word in lines(filename):
    if word.len == size:
      result.add(word)


# EXAMPLE: marry, major => 2 2 1 0 0
func score(guess: string, valid: string): seq[Score] =
  result.setLen(5)
  var left = ""
  for i in 0..<5:
    if guess[i] != valid[i]:
      left.add(valid[i])
  for i in 0..<5:
    if guess[i] == valid[i]:
      result[i] = 2
    elif guess[i] in left:
      result[i] = 1
      let idx = left.find(guess[i])
      left.delete(idx..idx)
    else:
      result[i] = 0


iterator wordleAnswers(data: Data, dict: Dict): string =
  let full = toSeq(0..<dict.len).toIntSet
  var this: IntSet
  var next: IntSet = full
  for item in data:
    swap(this, next)
    next.clear
    for idx in this:
      let score = item.guess.score(dict[idx])
      if score == item.score:
        next.incl(idx)
    assert next.card > 0
    if next.card == 1:
      for idx in next:
        yield dict[idx]
      next = full


func answer(word: string): int =
  word.mapIt(it.ord - 'a'.ord).sum


let data = parseData()
let dict = getWords("data/words.txt", 5)

assert dict.len == 8636
assert ["words", "mince"].mapIt(it.answer).sum == 113

benchmark:
  echo toSeq(data.wordleAnswers(dict)).mapIt(it.answer).sum

# 4150

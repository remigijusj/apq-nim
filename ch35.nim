import std/[strutils,sequtils,sets,tables,algorithm]
from math import ceilDiv, divmod
import utils/common

# Chop the text into lengths equal to the length of the code word, padding the end of the plaintext.
# Then use the code word to generate a selection order for the columns.
# The selection order is the order the letters in the word would take if they were sorted alphabetically.
# Ties are broken by position in the original word. Taking this column order, apply to the columns.
# Pull the columns out in that order, converting to lines. And then collapse into a single string.
#
# Your input is a ciphertext (remove "#" which has been added to note the end position).
# You have a handy list of words.txt, which will contain the code word.
# What is the code word used to encrypt the text in your input?

type
  Dict = HashSet[string]

  Order = seq[int]


proc parseData: string =
  readInput().strip(leading=false, chars={'\n', '#'})


proc getWords(filename: string): Dict =
  for word in lines(filename):
    result.incl(word)


func calcOrder(code: string): Order =
  toSeq(code.pairs).mapIt((it[1], it[0])).sorted.mapIt(it[1])


func encryptColumnar(input: string, order: Order): string =
  let count = ceilDiv(input.len, order.len) * order.len
  result = newStringOfCap(count)
  let input = input.alignLeft(count)
  for s in order:
    for x in countup(s, input.len-1, order.len):
      result.add input[x]


func decryptColumnar(input: string, order: Order): string =
  assert input.len mod order.len == 0
  result = newString(input.len)
  let chunk = input.len div order.len
  for i, c in input:
    let (m, r) = divmod(i, chunk)
    result[r * order.len + order[m]] = c


iterator singleCodeOrders(cipher: string, dict: Dict): Order =
  var cnt: CountTable[Order]
  for word in dict:
    if cipher.len mod word.len == 0:
      cnt.inc(word.calcOrder)
  for key, val in cnt.pairs:
    if val == 1:
      yield key


# heuristics
func breakColumnar(cipher: string, dict: Dict): string =
  for order in singleCodeOrders(cipher, dict):
    let text = cipher.decryptColumnar(order)
    if text[0].isUpperAscii and text.strip(leading=false)[^1] in PunctuationChars:
      let words = text.split(Whitespace + PunctuationChars)
      if words.countIt(it in dict) > words.len div 2:
        for code in dict:
          if code.calcOrder == order:
            return code


let data = parseData()
let dict = getWords("data/words.txt")

assert calcOrder("GLASS") == @[2, 0, 1, 3, 4]
assert calcOrder("LEVER") == @[1, 3, 0, 4, 2]
assert encryptColumnar("WE ARE DISCOVERED FLEE AT ONCE", "GLASS".calcOrder) == " DV  NWECEE E ODEOAIEFACRSRLTE"
assert calcOrder("SLANA") == @[2, 4, 1, 3, 0]
assert decryptColumnar("chmrw27ejoty49bglqv16dinsx38afkpuz5", @[2, 4, 1, 3, 0]) == "abcdefghijklmnopqrstuvwxyz123456789"

benchmark:
  echo data.breakColumnar(dict)

# nonsense

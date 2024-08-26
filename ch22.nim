import std/[strutils,sequtils]
import utils/common

# Convert your input set of numbers into Roman numerals. Then use a Caesar cipher (A=1, B=2, C=3 etc)
# to convert the letters of the Roman numerals into decimal numbers.
# The sum of these values is the answer.

const
  nums = [(1000, "M"), (900, "CM"), (500, "D"), (400, "CD"), (100, "C"), (90, "XC"),
          (50, "L"), (40, "XL"), (10, "X"), (9, "IX"), (5, "V"), (4, "IV"), (1, "I")]

type
  Data = seq[int]


proc parseData: Data =
  readInput().strip.splitWhitespace.map(parseInt)


proc toRoman(n: int): string =
  var n = n.int
  for (a, r) in nums:
    result.add(repeat(r, n div a))
    n = n mod a


func caesar(line: string): int =
  result = line.mapIt(it.ord - 'A'.ord + 1).sum


let data = parseData()

benchmark:
  echo data.mapIt(it.toRoman.caesar).sum

# 43103

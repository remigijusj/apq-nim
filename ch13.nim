import std/[strutils,sequtils]
from unicode import reversed
import utils/common

# The input contains a list of strings - they each contain a repeated sequence like the one above,
# however there are some extra characters on the beginning and/or end. Once these characters have been removed,
# what is the sum of the counts of the most repeated blocks in each string? Ex: AAAAAAB -> 6 (1,2,3)

type
  Data = seq[string]


proc parseData: Data =
  readInput().strip.splitLines


func maxRepeatLeft(line: string): int =
  for cov in 1..(line.len div 2):
    let sub = line[0 ..< cov]
    var num = 1
    var idx = 0
    while cov * (num + 1) <= line.len and line[cov * num ..< cov * (num + 1)] == sub:
      num.inc
      idx.inc
    if num > result:
      result = num


func maxRepeat(line: string): int =
  max(line.maxRepeatLeft, line.reversed.maxRepeatLeft)


let data = parseData()

benchmark:
  echo data.map(maxRepeat).sum

# 1462

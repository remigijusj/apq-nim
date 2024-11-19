import std/[strutils,sequtils]
import utils/common

# What is the minimum number of darts will you need to hit the exact score in your input,
# and in a separate game for each, every number on the way there?
# A single dart can score all the numbers from 1 to 20
#   1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
# as well as the doubles and triples of those numbers on the double score and triple score segments,
#   2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40
#   3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48 51 54 57 60
# and in the bullseye:
#   25 50

const
  single = toSeq(1..20)
  scores = single & single.mapIt(it * 2) & single.mapIt(it * 3) & @[25,50]


proc parseData: int =
  readInput().strip.parseInt


func minDartsSeq(hit: int): seq[int] =
  result.add(0)
  for n in 1..hit:
    var m = int.high
    for s in scores:
      if n-s >= 0 and result[n-s] < m:
        m = result[n-s]
    result.add(m + 1)


let data = parseData()

benchmark:
  echo data.minDartsSeq.sum

# 503234559

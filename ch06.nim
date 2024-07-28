import std/[strscans,strutils]
import utils/common

# https://en.wikipedia.org/wiki/Composition_(combinatorics)
# weak k-kompositions of n
# count = (n + k - 1, k - 1)
# https://stackoverflow.com/questions/15577651/generate-all-compositions-of-an-integer-into-k-parts

type
  Data = tuple[k, n: int]


proc parseData: Data =
  let line = readInput().strip
  assert line.scanf("$i numbers which sum to $i", result.k, result.n)


iterator compositions(n, k: int): seq[int] =
  var comp = newSeq[int](k)
  comp[k-1] = n
  yield comp
  while comp[0] < n:
    # find the last index where value is > 0
    var last = k-1
    while comp[last] == 0:
      last.dec
    # shift to next composition
    let z = comp[last]
    comp[last-1].inc
    comp[last] = 0
    comp[k-1] = z-1
    yield comp


func sumOnes(data: Data): int =
  for comp in compositions(data.n, data.k):
    for m in comp:
      result += count($m, '1')


let data = parseData()
echo data

benchmark:
  echo data.sumOnes

# 6927

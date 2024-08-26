import std/[strutils]
from math import binom
import utils/common


proc parseData: string =
  readInput().strip


# generic
func countNonDecreasing(limit: string): int =
  let m = limit.len
  let d = limit[0].ord - '0'.ord
  if m == 1:
    return d + 1

  assert d > 0
  result = binom(m + 9, m) - binom(m + 9 - d, m)

  let pivot = repeat($d, m)
  let delta = limit.parseInt - pivot.parseInt
  if delta >= 0:
    result += countNonDecreasing($delta)


var data = parseData()

benchmark:
  echo countNonDecreasing(data)

# 47905

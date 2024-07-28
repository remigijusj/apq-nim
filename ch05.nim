import std/[strutils]
import utils/common

# Data is series of directions - up (U), down (D), left (L), or right (R), to spin the current front face of each dice.
#
# Dice 1:
#   Front: 1
#   Left:  2
#   Top: 3
#
# Dice 2:
#   Front: 1
#   Left:  3
#   Top: 2

type
  Data = string

  # 0 1 2 3 4 5
  # F L T D R B
  Dice = array[6, int]

const
  dice1: Dice = [1, 2, 3, 4, 5, 6]
  dice2: Dice = [1, 3, 2, 5, 4, 6]


proc parseData: Data =
  readInput().strip


proc permute(d: var Dice, c: char) =
  let b = d
  case c
    of 'L': d[0] = b[4]; d[4] = b[5]; d[5] = b[1]; d[1] = b[0]
    of 'R': d[0] = b[1]; d[1] = b[5]; d[5] = b[4]; d[4] = b[0]
    of 'U': d[0] = b[3]; d[3] = b[5]; d[5] = b[2]; d[2] = b[0]
    of 'D': d[0] = b[2]; d[2] = b[5]; d[5] = b[3]; d[3] = b[0]
    else: assert false


func sumIndices(data: Data): int =
  var d1 = dice1
  var d2 = dice2
  for ix, c in data:
    d1.permute(c)
    d2.permute(c)
    if d1[0] == d2[0]:
      result += ix


let data = parseData()

benchmark:
  echo data.sumIndices

# 10704

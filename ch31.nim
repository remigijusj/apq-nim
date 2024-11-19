import std/[strutils]
from std/math import sgn
import utils/common

# Rubik scrambling.
# Starting with the origin cube and following the instructions in your input,
# what is the product of digits on the front face on the cube after executing every rotation in order?

type
  Move = tuple
    sign: range[-1..1]
    axis: range[0..2]
    x, y: range[0..2]

  Data = seq[Move]

  Vec = array[3, range[-2..2]]


const
  faces = "FULRDB" # -> 123456

  moves: seq[Move] = @[
    (1, 0, 2, 1), (1, 2, 1, 0), (-1, 1, 2, 0), (1, 1, 0, 2), (-1, 2, 0, 1), (-1, 0, 1, 2)
  ]


proc parseData: Data =
  for c in readInput().strip:
    if c == '\'':
      swap(result[^1].x, result[^1].y)
    else:
      result.add moves[faces.find(c)]


iterator vectors: (Vec, int) =
  var vec: Vec
  for i, move in moves:
    vec[move.axis] = 2 * move.sign
    for a in -1..1:
      vec[move.x] = a
      for b in -1..1:
        vec[move.y] = b
        yield (vec, i+1)


proc apply(vec: var Vec, move: Move) =
  if vec[move.axis].sgn == move.sign:
    swap(vec[move.x], vec[move.y])
    vec[move.x] *= -1


func scrambledFrontProd(data: Data): int =
  result = 1
  for v, value in vectors():
    var vec = v
    for move in data:
      vec.apply(move)
    if vec[0] == 2:
      result *= value


let data = parseData()

benchmark:
  echo data.scrambledFrontProd

# 7200

import std/[strutils,sequtils]
import utils/common

# Someone has left an extremely detailed record of the last several thousand darts thrown.
# All the players are excellent and never miss.
# Each player starts with 0 points, and the goal is to get to 501 by adding each throw to the current player's total. A leg of darts consists of each player throwing three darts, then handing over to the other player. When a player hits 501 points, they win that leg, and the next starts immediately. Players alternate being first on each leg.
# The challenge is, from the input, to determine how many legs player A wins,
# and multiply that by the sum of the value of the winning dart in each leg.

type
  Data = seq[int]


proc parseData: Data =
  readInput().strip.split(' ').map(parseInt)


func finalScore(throws: seq[int]): int =
  var first, turn, dart, winsA, finals: int
  var score: array[2, int]
  for throw in throws:
    dart.inc
    score[turn] += throw

    if score[turn] >= 501: # finish leg
      score = [0, 0]
      finals += throw
      if turn == 0: winsA.inc
      dart = 0
      first = 1 - first
      turn = first

    elif dart == 3: # change turn
      dart = 0
      turn = 1 - turn

  result = winsA * finals


let data = parseData()

benchmark:
  echo data.finalScore

# 10960536

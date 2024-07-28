import std/[strscans,strutils,sequtils,tables]
from math import pow
import utils/common

# The way Elo works is by comparing the expected win rate of two head-to-head competitors,
# calculated for player a with:
#   Ea = 1 / (1 + 10^((Rb-Ra)/400))
#
# Here, Ra and Rb are the ratings of teams a and b - which start at 1200 and are modified with:
#   Ri' = Ri + 20(1-Ei)
# where Ri is the old ranking, and Ri' is the updated ranking for the winning team -
# 20(1-Ei) is the amount of points the winner gains and the loser loses.
#
# For example, if Ra is 1400 and Rb is 1200, a has an expected win rate of around 0.75 over b,
# and if a wins, Ra gains, and Rb loses, about 5 points each.
# Conversely if b wins, b gains and a loses 15 points.


type
  Game = tuple
    one, two: string
    s1, s2: int

  Data = seq[Game]

  Rating = Table[string, float]


func parseGame(line: string): Game =
  assert line.scanf("$+,$+,$i-$i", result.one, result.two, result.s1, result.s2)


proc parseData: Data =
  let lines = readInput().strip.splitLines
  for line in lines:
    if line == "h,a,score": continue
    result.add line.parseGame


func ewr(ra, rb: float): float =
  result = 1.0 / (1.0 + pow(10, (rb-ra) / 400.0))


func eloRating(data: Data): Rating =
  for game in data:
    var (one, two) = (game.one, game.two)
    if game.s1 < game.s2: swap(one, two)
    let r1 = result.getOrDefault(one, 1200.0)
    let r2 = result.getOrDefault(two, 1200.0)
    let delta = 20.0 * (1.0 - ewr(r1, r2))
    result[one] = r1 + delta
    result[two] = r2 - delta


func minmaxDiff(rating: Rating): int =
  let (lo, hi) = rating.values.toSeq.minmax
  result = hi.int - lo.int


let data = parseData()

benchmark:
 echo data.eloRating.minmaxDiff

# 77

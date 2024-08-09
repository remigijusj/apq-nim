import std/[strscans,strutils,sequtils,sets]
import utils/common

# The designer then specifies that he doesn't want any areas that don't overlap others
# included in the final plan - if an area doesn't directly overlap with another, disregard it entirely.
# In the resulting set of areas, some tiles overlap - there's no point in placing more than one tile per spot,
# so how many tiles do you need total to complete the plan?

type
  Area = tuple
    lx, ly, ux, uy: int

  Data = seq[Area]

  Tile = tuple[x, y: int]


func parseArea(line: string): Area =
  assert line.scanf("$i,$i,$i,$i", result.lx, result.ly, result.ux, result.uy)
  assert result.lx <= result.ux and result.ly <= result.uy


proc parseData: Data =
  readInput().strip.splitLines[1..^1].map(parseArea)


func intersects(a1, a2: Area): bool =
  not (a1.ux <= a2.lx or a2.ux <= a1.lx) and not (a1.uy <= a2.ly or a2.uy <= a1.ly)


iterator tiles(area: Area): Tile =
  for x in area.lx ..< area.ux:
    for y in area.ly ..< area.uy:
      yield (x, y)


func collectTiles(data: Data): HashSet[Tile] =
  for i, a in data:
    if data.anyIt(it != a and it.intersects(a)):
      for tile in a.tiles:
        result.incl(tile)


let data = parseData()

benchmark:
  echo data.collectTiles.card

# 216

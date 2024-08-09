import std/[strscans,strutils,sequtils]
import utils/common

# The first number indicates whether you should continue in the same direction (1)
# or immediately reverse direction (0).
# After this is decided, the second number indicates how many floors you should immediately move by.
# You continue in the same direction until you see a zero instruction in the first number.
# Your working day is over when you land on a floor without instructions.

type
  Item = tuple
    keep, count: int

  Data = seq[Item]


func parseItem(line: string): Item =
  assert line.scanf("$i $i", result.keep, result.count)
  assert result.keep in [0, 1]


proc parseData: Data =
  readInput().strip.splitLines.map(parseItem)


func visitedFloors(data: Data): int =
  var floor = 0
  var dir = 1 # up
  while true:
    result.inc
    if floor < 0 or floor >= data.len:
      break
    let (keep, count) = data[floor]
    if keep == 0: dir = -dir
    floor += dir * count


let data = parseData()

benchmark:
  echo data.visitedFloors

# 353

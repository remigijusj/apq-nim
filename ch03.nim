import std/[strutils]
import utils/common

#  012345
# 0  ##  
# 1 #### 
# 2######
# 3######
# 4 #### 
# 5  ##  

type
  XY = tuple[x, y: int]
  Data = string

const start: XY = (2, 0)


proc parseData: Data =
  readInput().strip


proc move(pos: XY, c: char): XY =
  result = pos
  case c
    of 'U': result.y.dec
    of 'D': result.y.inc
    of 'L': result.x.dec
    of 'R': result.x.inc
    else: assert false


func inside(pos: XY): bool =
  result = (pos.x + pos.y) in 2..8 and (pos.x - pos.y) in -3..3


iterator follow(data: Data, start: XY): XY =
  var this = start
  for c in data:
    let next = this.move(c)
    if next.inside:
      this = next
    yield this


func sumIndices(data: Data): int =
  for pos in data.follow(start):
    result += pos.x + pos.y


let data = parseData()

benchmark:
  echo data.sumIndices

# 2543

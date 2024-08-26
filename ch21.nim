import std/[strutils,sequtils]
import utils/common

# allway floor is covered in a grid of square tiles, and is 20 tiles wide and 500 long.
# Each tile is covered in a certain amount of dust motes. Quickly you estimate this coverage
# as relative integers, and note them as your input. Your vacuum cleaner attachment is 5 tiles wide,
# and for an effective cleaning action, you have to run it so it exactly covers whole tiles.
# You have time for exactly one pass down the hallway, and can move your vacuum cleaner
# left or right one tile at a time, or continue straight, as you move forward one tile at a time.
# In your single pass down the hallway, starting from any tile on the first row and moving the whole way
# down, how many motes of dust can you collect, assuming you clean all the dust from each tile?

type
  Data = seq[seq[int]]


func parseRow(line: string): seq[int] =
  line.splitWhitespace.map(parseInt)


proc parseData: Data =
  readInput().strip.splitLines.map(parseRow)


func windowSum(row: seq[int], wide: int): seq[int] =
  for i in 0..(row.len-wide):
    result.add(row[i..<(i+wide)].sum)


func maxCollected(data: Data): seq[int] =
  let size = data[0].len
  result.setLen(size)
  for i, row in data:
    let prev = result
    for j, val in row:
      result[j] = val + prev[max(j-1, 0)..min(j+1, size-1)].max


let data = parseData()

benchmark:
  echo data.mapIt(it.windowSum(5)).maxCollected.max

# 143487

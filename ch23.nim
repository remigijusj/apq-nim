import std/[strutils,sequtils]
import utils/common

# Your input is text encrypted with this method, using the keyword "power plant" -
# what is the prepared plaintext from this ciphertext?
# (The answer will contain no "j"s, no spaces, and may be padded with "x"s).

const
  alphabet = "abcdefghiklmnopqrstuvwxyz" # no j

type
  Grid = seq[string]

  XY = tuple[x, y: int]


proc parseData: string =
  readInput().strip


func buildGrid(keyword: string): Grid =
  let head = keyword.replace(" ").deduplicate.join
  let tail = alphabet.filterIt(it notin head).join
  let perm = head & tail
  for i in 0..4:
    result.add perm[i*5 ..< (i+1)*5]


func locate(grid: Grid, c: char): XY =
  for y, row in grid:
    for x, val in row:
      if val == c:
        return (x, y)


func decrypt(grid: Grid, a, b: char): string =
  let aa = grid.locate(a)
  let bb = grid.locate(b)
  if aa.x == bb.x:
    return grid[(aa.y+4) mod 5][aa.x] & grid[(bb.y+4) mod 5][bb.x]
  if aa.y == bb.y:
    return grid[aa.y][(aa.x+4) mod 5] & grid[bb.y][(bb.x+4) mod 5]
  return grid[aa.y][bb.x] & grid[bb.y][aa.x]


func decrypt(data, keyword: string): string =
  let grid = keyword.buildGrid
  for i in countup(0, data.len-2, 2):
    result &= grid.decrypt(data[i], data[i+1])


let data = parseData()

benchmark:
  echo data.decrypt("power plant")

# youlxlhavetospeakupimwearingatowel

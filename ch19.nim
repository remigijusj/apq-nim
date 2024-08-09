import std/[strutils,sequtils]
import utils/common

# Cell neighbours are considered the cell above, below, left, and right of the current cell - no diagonals.
# If a cell has an even number of surrounding "on" states, it should be set to (or remain) off.
# If a cell has an odd number of surrounding "on" states, it should be set to (or remain) on.
# Points outside the boundary are considered to be "off".
#
# Your input is multiple sets of run times, square grid widths, and the matrix index pairs of starting cells.
# What is the sum of the living cells after the required run time for each input?

type
  Grid = seq[string]

  Spec = tuple
    gens: int
    grid: Grid

  Data = seq[Spec]


func buildGrid(size: int, list: seq[int]): Grid =
  result = newSeqWith(size, '.'.repeat(size))
  for i in countup(0, list.len-2, 2):
    let row = list[i]
    let col = list[i+1]
    result[row][col] = '#'


func parseSpec(line: string): Spec =
  let nums = line.splitWhitespace.map(parseInt)
  result.gens = nums[0]
  result.grid = buildGrid(nums[1], nums[2..^1])


proc parseData: Data =
  readInput().strip.splitLines.map(parseSpec)


func neighbors(grid: Grid, r, c: int): int =
  let s = grid.len
  if r > 0   and grid[r-1][c] == '#': result.inc
  if c > 0   and grid[r][c-1] == '#': result.inc
  if c < s-1 and grid[r][c+1] == '#': result.inc
  if r < s-1 and grid[r+1][c] == '#': result.inc


proc iterate(grid: Grid, gens: int): Grid =
  let size = grid.len
  var (a, b) = (grid, grid)
  for _ in 1..gens:
    swap(a, b)
    for r in 0..<size:
      for c in 0..<size:
        let alive = a.neighbors(r, c) mod 2 == 1
        b[r][c] = if alive: '#' else: '.'
  result = b


func countAlive(spec: Spec): int =
  result = iterate(spec.grid, spec.gens).join.count('#')


let data = parseData()

benchmark:
  echo data.map(countAlive).sum

# 2481, <3min

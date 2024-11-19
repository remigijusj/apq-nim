import std/[strutils,sequtils,algorithm,random]
import utils/[common,blossom]

# Tetonor puzzles
#
# Each number in the main grid can be formed by adding or multiplying a pair of numbers from the input below.
# Each pair of numbers should be used twice: once as part of an addition and once as part of a multiplication.
# Any unknowns in the input must be deduced, with the numbers listed in non-descending order.
# The "answer" for a grid is the sum of the absolute differences of the pairs. The sum of those is the final answer.

const
  size = 16

type
  Grid = seq[int]

  Input = seq[int] # -1 for unknown

  Puzzle = tuple
    grid: Grid
    input: Input

  Data = seq[Puzzle]

  Candidate = tuple # a * b = grid[pi], a + b = grid[si], a <= b
    a, b, pi, si: int

  Graph = seq[(int, int)]

  Pack = seq[Candidate]


func parsePuzzle(chunk: string): Puzzle =
  let lines = chunk.split("\n")
  assert lines.len == 2 and lines[0].startsWith("g:") and lines[1].startsWith("i:")
  result.grid = lines[0][2..^1].split(' ').map(parseInt)
  result.input = lines[1][2..^1].replace("*", "-1").split(' ').map(parseInt)
  assert result.grid.len == size and result.input.len == size


proc parseData: Data =
  readInput().strip(leading=false).split("\n\n").map(parsePuzzle)


# Split grid numbers as product and check if sum also exists.
func candidates(grid: Grid): seq[Candidate] =
  for pi, n in grid:
    for a in 1..isqrt(n):
      if n mod a == 0:
        let b = n div a
        for si, m in grid:
          if si == pi: continue
          if a + b == m:
            result.add (a, b, pi, si)


# Does n fit as input?
func compatible(input: Input, n: int): bool =
  var rng = 0..0
  var undef = false
  for x in input:
    if x == -1:
      undef = true
    else:
      if undef:
        rng.b = x
        if n in rng: return true
      rng = x..x
      if n in rng: return true
  if undef:
    if n >= rng.a: return true


# Use simple graph perfect matching
func matching(graph: Graph): Graph =
  var simple = newSeqWith(size, newSeq[int]())
  for (a, b) in graph:
    simple[a].add(b)
    simple[b].add(a)
  let matching = maxMatching(simple)
  for i, v in matching:
    if i < v:
      result.add (i, v)
  assert result.len == size div 2


func transform(graph: Graph, perm: seq[int]): Graph =
  for (a, b) in graph:
    result.add (perm[a], perm[b])


# Shuffle and match, starting with identity
iterator matchings(graph: Graph): Graph =
  var change = toSeq(0..<size)
  var invert = newSeq[int](size)
  while true:
    for i, v in change:
      invert[v] = i
    let match = graph.transform(change).matching.transform(invert)
    yield match
    shuffle(change)


func fits(pack: Pack, input: Input): bool =
  assert pack.len == size div 2
  var numbers: seq[int]
  for (a, b, _, _) in pack:
    numbers.add(a)
    numbers.add(b)
  numbers.sort
  for i in 0..<size:
    if input[i] == -1: continue
    if input[i] != numbers[i]:
      return false
  return true


# Assume uniqueness
func buildPack(matching: Graph, list: seq[Candidate]): Pack =
  for (a, b) in matching:
    let idx = list.findIt((it.pi == a and it.si == b) or (it.si == a and it.pi == b))
    result.add list[idx]


proc findPack(puzzle: Puzzle): Pack =
  let (grid, input) = puzzle
  let list = grid.candidates
  let good = list.filterIt(input.compatible(it.a) and input.compatible(it.b))
  # optimistic
  for matching in good.mapIt((it.pi, it.si)).matchings:
    result = matching.buildPack(good)
    if result.fits(input):
      return
  assert false


func answer(pack: Pack): int =
  pack.mapIt(it.b - it.a).sum


let data = parseData()

benchmark:
  echo data.mapIt(it.findPack.answer).sum

# 1298

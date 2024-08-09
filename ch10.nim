import std/[strscans,strutils,sequtils,heapqueue]
import utils/common

# Given a graph where each edge has assigned cost (both ways are defined).
# Find minimum total cost from the given source to the destination.

type
  Edge = tuple
    src, dst: string
    cost: int

  Data = seq[Edge]

  Graph = object
    nodes: seq[string]
    costs: seq[seq[int]]

  Item = tuple
    node, prio: int


func parseEdge(line: string): Edge =
  assert line.scanf("$+,$+,$i", result.src, result.dst, result.cost)


proc parseData: Data =
  readInput().strip.splitLines[1..^1].map(parseEdge)


func buildGraph(data: Data): Graph =
  result.nodes = data.mapIt(it.src).deduplicate
  result.costs = newSeqWith(result.nodes.len, newSeqWith(result.nodes.len, -1))
  for it in data:
    let a = result.nodes.find(it.src)
    let b = result.nodes.find(it.dst)
    assert a >= 0 and b >= 0
    result.costs[a][b] = it.cost
    assert result.costs[b][a] in [-1, it.cost]


# Dijkstra algorithm
func minCost(graph: Graph, src, dst: string): int =
  let start = graph.nodes.find(src)
  let final = graph.nodes.find(dst)
  assert start >= 0 and final >= 0

  var costs = newSeqWith(graph.nodes.len, int.high)
  costs[start] = 0
  var queue: HeapQueue[Item]
  queue.push (start, 0)

  while queue.len > 0:
    let (this, cost) = queue.pop
    if this == final:
      return cost
    for next, edge in graph.costs[this]:
      if edge == -1 or next == this:
        continue
      if cost + edge < costs[next]:
        costs[next] = cost + edge
        queue.push (next, costs[next])


let data = parseData()

benchmark:
  echo data.buildGraph.minCost("TUPAC", "DIDDY")

# 596

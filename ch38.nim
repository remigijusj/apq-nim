import std/[strutils,sequtils]
import utils/common
import bitty

# Numbers in a list like being part of a streak which sums to a multiple of the length of the streak.
# Each number in the list evaluates its streaks in ascending order, and in order to feel both comfortable
# AND cosy, it checks for the length of the unbroken streak of comfortable streaks. No restart if broken.
# For each list, determine the total comfort score of each list,
# and sum each of these to get the total comfort score of the input.

type
  Data = seq[seq[int]]


proc parseData: Data =
  readInput().strip.split('\n').mapIt(it.split(' ').map(parseInt))


func calcStreaks(list: seq[int]): BitArray2d =
  result = newBitArray2d(list.len, list.len)
  var prev = newSeq[int](list.len)
  var this = newSeq[int](list.len)
  for n in 1..list.len:
    for i in 0..<list.len:
      let part = if i+1 < list.len: prev[i+1] else: 0
      this[i] = list[i] + part
      if this[i] mod n == 0:
        result[n-1, i] = true
    swap(this, prev)


func comfortScores(list: seq[int]): seq[int] =
  result.setLen(list.len)
  let streaks = list.calcStreaks
  for i in 0..<list.len:
    for n in 1..list.len:
      var comfy = false
      for j in max(i-n+1, 0)..min(i, list.len-n):
        if j notin 0..<list.len:
          continue
        if streaks[n-1, j]:
          comfy = true
          break
      if comfy:
        result[i].inc
      else:
        break


let data = parseData()

benchmark:
  echo data.mapIt(it.comfortScores.sum).sum

# 131086

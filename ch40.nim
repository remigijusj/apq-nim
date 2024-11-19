import std/[strutils,sequtils]
import utils/common

# A map of the mountain range consists of the numbers representing the heights of the range.
# Prominences are the smallest drop in height from a summit to reach higher or equal-height ground.
# If you can't reach higher ground, it has a prominence that is its own height.
# Non-peak numbers have no prominence, or prominence 0.
# What is the sum of the prominences?

type
  Data = seq[int]


proc parseData: Data =
  readInput().strip.split(' ').map(parseInt)


func calcPeaks(data: Data): seq[bool] =
  result.setLen(data.len)
  for i, level in data:
    if i > 0 and i < data.len-1 and level > data[i-1] and level > data[i+1]:
      result[i] = true


func findBottom(data: Data, start: int, step: int, peaks: seq[bool]): int =
  result = int.high
  let level = data[start]
  var here = start + step
  while here in 0..<data.len:
    let value = data[here]
    if value < result:
      result = value
    if value >= level and peaks[here]:
      return
    here += step
  result = 0


iterator prominences(data: Data): int =
  let peaks = data.calcPeaks
  let top = data.max
  for i, level in data:
    if not peaks[i]:
      continue
    if level == top:
      yield level
    else:
      let bottom1 = data.findBottom(i, 1, peaks)
      let bottom2 = data.findBottom(i, -1, peaks)
      yield level - max(bottom1, bottom2)


let data = parseData()

benchmark:
  echo data.prominences.toSeq.sum

# 6750

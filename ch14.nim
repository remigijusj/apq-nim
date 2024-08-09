import std/[strutils,sequtils]
import utils/common

# In this game, you win when you get all the numbers in a row, column or diagonal. 
# What is the sum of the amount of numbers it takes in each row to end the game?

const
  Bingo = [
    [ 6, 17, 34, 50, 68],
    [10, 21, 45, 53, 66],
    [ 5, 25, 36, 52, 69],
    [14, 30, 33, 54, 63],
    [15, 23, 41, 51, 62],
  ]

type
  Data = seq[seq[int]]


func parseLine(line: string): seq[int] =
  line.split(" ").map(parseInt)


proc parseData: Data =
  readInput().strip.splitLines.map(parseLine)


func turnsToWin(list: seq[int]): int =
  assert list.deduplicate.len == list.len
  var found: array[12, int]
  for i, val in list:
    for r, row in Bingo:
      for c, bval in row:
        if bval == val:
          found[r].inc
          found[5+c].inc
          if r == c:
            found[10].inc
          if r+c == 4:
            found[11].inc
          if found.find(5) >= 0:
            return i+1


let data = parseData()

benchmark:
  echo data.map(turnsToWin).sum

# 4327

# AquaQ Challenge Hub - Challenge 1

import std/[strscans,strutils,sequtils]
import utils/common

#   1   2   3
#      abc def
#
#   4   5   6
#  ghi jkl mno
#
#   7   8   9
# pqrs tuv wxyz
#
#       0
#       _

const
  Pad = [" ", "", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz"]

type
  Item = tuple
    digit, times: int

  Data = seq[Item]


func parseItem(line: string): Item =
  assert line.scanf("$i $i", result.digit, result.times)


proc parseData: Data =
  readInput().strip.splitLines.map(parseItem)


func getChar(i: Item): char =
  assert i.digit in 0..9
  let p = Pad[i.digit]
  assert i.times in 1..p.len
  result = p[i.times-1]


let data = parseData()

benchmark:
  echo data.map(getChar).join

# "oh so they have internet on computers now"

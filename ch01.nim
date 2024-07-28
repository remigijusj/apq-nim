import std/[strutils,sequtils]
import utils/common

# Set the string's non-hexadecimal characters to 0.
# Pad the string length to the next multiple of 3.
# Split the result into 3 equal sections.
# The first two digits of each remaining section are the hex components.
#
# kdb4life -> 0d40fe

const Hex = "0123456789abcdef"

proc parseData: string =
  readInput().strip


func adjust(c: char): char {.inline.} =
  result = if c in Hex: c else: '0'


func makeHex(data: string): string =
  for sub in data.toSeq.distribute(3, false):
    result.add sub[0].adjust
    result.add sub[1].adjust


let data = parseData()

benchmark:
  echo data.makeHex

# d0000d

import std/[strutils,sequtils]
import memo
import utils/common

# Cards in hand are face-up (1) or face-down (0).
# Each step of the game involves removing a face-up card and flipping over any cards immediately adjacent to it.
# The empty space left behind is never refilled. The game ends when the cards have either been removed entirely
# (in which case, you win!) or no valid moves remain.
# Treating your input as a set of dealt hands, work out how many valid starting positions are in that set.

type
  Hand = seq[uint8]

  Data = seq[Hand]


func parseHand(line: string): Hand =
  line.mapIt("01".find(it).uint8)


proc parseData: Data =
  readInput().strip.split('\n').map(parseHand)


func left(hand: Hand, pos: int): Hand =
  result = hand[0..<pos]
  if result.len > 0:
    result[^1] = result[^1] xor 1


func right(hand: Hand, pos: int): Hand =
  result = hand[(pos+1)..^1]
  if result.len > 0:
    result[0] = result[0] xor 1


func winnable(hand: Hand): bool {.memoized.} =
  if hand.len == 0:
    return true
  for i in countup(0, hand.len-1):
    if hand[i] == 1 and left(hand, i).winnable and right(hand, i).winnable:
      return true


proc countGoodStarts(hand: Hand): int =
  for i in 0..<hand.len:
    if hand[i] == 1 and left(hand, i).winnable and right(hand, i).winnable:
      result.inc


let data = parseData()

benchmark:
  echo data.map(countGoodStarts).sum

# 8069, in 82s

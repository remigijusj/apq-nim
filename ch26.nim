import std/[strutils,sequtils,algorithm]
import bigints
import utils/common

# Re-arrange the numerals in each input number to create the next largest integer which uses all the same numerals.
# If the current number is the largest available, leave it as it is.
# The answer to the challenge is the total of your ill-gotten gains,
# i.e. the sum of the differences between your input and the re-arranged next-largest numbers.

type
  Data = seq[string]


proc parseData: Data =
  result = readInput().strip.splitWhitespace


# Onw, r-find an increasing pair.            : 23 in 2331
# Two, r-find a larger digit than the first. : 3 (second)
# Three, swap the two positions.             : 3321
# Four, reverse the tail.                    : 3123
func nextLargest(this: string): string =
  var next = this.toSeq

  var i = next.len-2
  while i >= 0 and next[i] >= next[i+1]:
    i.dec
  if i < 0: return next.join

  var j = next.len-1
  while next[i] >= next[j]:
    j.dec

  swap(next[i], next[j])
  reverse(next, i+1, next.len-1)
  return next.join


func gain(this: string): BigInt =
  let next = this.nextLargest
  result = next.initBigInt - this.initBigInt


let data = parseData()

benchmark:
  echo data.map(gain).sum

# 11923911

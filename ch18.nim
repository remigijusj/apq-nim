import std/[strscans,strutils,sequtils]
import utils/common

# Your input is a list of times - for each time, how far away, in seconds,
# is the nearest palindromic time, in hh:mm:ss format?
# The answer is the sum of these differences.
# Note that the nearest palindromic time might be in the past.

type
  Time = tuple
    hour, min, sec: int

  Data = seq[Time]


func parseTime(line: string): Time =
  assert line.scanf("$i:$i:$i", result.hour, result.min, result.sec)


proc parseData: Data =
  readInput().strip.splitLines.map(parseTime)


iterator palindromes: Time =
  for hour in 0..23:
    for m in 0..5:
      let min = m * 10 + m
      let sec = (hour mod 10) * 10 + (hour div 10)
      if sec < 60:
        yield (hour, min, sec)
  yield (24, 0, 0)


func delta(a, b: Time): int =
  result = (b.hour - a.hour) * 3600 + (b.min - a.min) * 60 + (b.sec - a.sec)


proc secondsToPalindrome(time: Time): int =
  result = int.high
  for pali in palindromes():
    let seconds = delta(pali, time).abs
    if seconds < result:
      result = seconds


let data = parseData()

benchmark:
  echo data.map(secondsToPalindrome).sum

# 719126

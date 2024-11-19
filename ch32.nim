import std/[strutils,sequtils]
import utils/common

# Determine how many lines have brackets (the above set of "()[]{}")
# which are correctly balanced - that is, the same number of opening and closing pairs,
# and no pairs which are incorrectly split by other brackets or missing another half.
# The answer is the total number of balanced lines in your input.

const
  parens = "()[]{}"

type
  Data = seq[string]


proc parseData: Data =
  readInput().strip.split('\n')


func balanced(line: string): bool =
  var stack: seq[int]
  for c in line:
    let i = parens.find(c)
    if i < 0: continue
    if i mod 2 == 0:
      stack.add(i)
    else:
      if stack.len > 0 and stack[^1] == i-1:
        stack.setLen(stack.len-1)
      else:
        return false
  return stack.len == 0


let data = parseData()

benchmark:
  echo data.countIt(it.balanced)

# 616

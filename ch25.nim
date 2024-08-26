import std/[strscans,strutils,sequtils,tables,sugar]
import utils/common

# Morse cipher.
# Decode a message from the sequence of clicks represented by timestamps.
# A dot is one "unit" long, and a dash is three units.
# Each element of a letter has a single unit between dots and dashes.
# The space between adjacent letters is three units (with no other additional spacing needed)
# and the space between words is seven units.

type
  Data = seq[int]

  Code = Table[string, char]


func parseTimestamp(line: string): int =
  var hh, mm, ss, mili: int
  assert line.scanf("$i:$i:$i.$i", hh, mm, ss, mili)
  result = (((hh * 60) + mm) * 60 + ss) * 1000 + mili


proc parseData: Data =
  result = readInput().strip.splitWhitespace.map(parseTimestamp)


proc parseCode(filename: string): Code =
  let lines = readFile(filename).strip.split("\n")
  result = collect:
    for line in lines:
      assert line.len >= 4, line
      {line[3..^1]: line[0]}


func simplify(data: Data): Data =
  for i in 1..<data.len:
    result.add(data[i] - data[i-1])
  let unit = result.min
  assert result.allIt(it mod unit == 0 or it > unit * 7)
  result.applyIt(it div unit)
  result.add(3) # final stop


func decode(data: Data, code: Code): string =
  var letter: string
  for i, size in data:
    if i mod 2 == 0:
      case size
        of 1: letter &= '.'
        of 3: letter &= '-'
        else: assert false
    else:
      if size == 1: continue
      result &= code[letter]
      case size
        of 3: discard
        of 7: result &= ' '
        else: result &= '\n' # > 7
      letter = ""


let data = parseData()
let code = parseCode("data/morse.txt")

benchmark:
  echo data.simplify.decode(code)

# the first letter of the answer is p
# the second character is q and the first letter is still p
# the third alphanumeric element is r and the second letter is now a
# the fourth is i
# test line please ignore zxcociquuzeotrwnqyiewmnaxzxcvl
# the final glyph is the letter following r in the alphabet

# PARIS

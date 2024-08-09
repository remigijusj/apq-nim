import std/[strutils,sequtils,tables]
import utils/common

# Kerning rule: join chars together moving the letters closer together until the nearest horizontal
# points between them are separated by a single space (filled with dots in this case to show spacing).
# Convert your input string into the appropriate ASCII characters in the above link,
# and join them together while applying the kerning rule -
# what is the total number of empty spaces in the resulting set of strings?

const
  alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

type
  Data = seq[string]

  Char = seq[string]

  Font = object
    chars: Table[char, Char]
    kerning: Table[string, int]


proc parseData: Data =
  readInput().strip.splitLines


func valid(c: Char): bool =
  let ws = c.mapIt(it.len).deduplicate
  c.len == 6 and ws.len == 1 and ws[0] in [1,5,6]


proc getChars(filename: string): seq[Char] =
  result = readFile(filename).strip(leading=false).splitLines.distribute(26)
  assert result.len == 26 and result.allIt(it.valid)


func calcKerning(a, b: Char): int =
  result = int.high
  for i in 0..5:
    let d1 = a[i].len - a[i].rfind('#') - 1
    let d2 = (b[i].find('#') + b[i].len) mod b[i].len
    let d = d1 + d2 - 1
    if d < result:
      result = d


func buildFont(chars: seq[Char]): Font =
  for i, a in chars:
    result.chars[alphabet[i]] = a
    for j, b in chars:
      let key = alphabet[i] & alphabet[j]
      result.kerning[key] = calcKerning(a, b)


func merge(a, b: char): char {.inline.} = 
  if a == '#': a else: b


func render(font: Font, line: string): seq[string] =
  result.setLen(6)
  var prev = ' '
  for this in line:
    assert this in alphabet
    let delta = font.kerning.getOrDefault(prev & this, 0)
    for i, row in font.chars[this]:
      if delta < 0: # add padding
        result[i] &= ' ' & row
      else:
        for j in 1..delta:
          result[i][^j] = merge(result[i][^j], row[delta-j])
        result[i] &= row[delta..^1]
    prev = this


let data = parseData()
let font = getChars("data/alphabet.txt").buildFont

benchmark:
  echo data.mapIt(font.render(it).join.count(' ')).sum

# 246882

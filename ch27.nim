import std/[strutils,sequtils,sets]
import utils/common

# Find all the words in the snakes in your challenge input.
# Once the words have been found, your answer is the sum of the value of each of the words.
# The value of a word is found by getting the letter values of that word (a=1, b=2, etc),
# summing them, and multiplying by the count of letters in the word.
# There is more than one snake in your input - the answer is the sum of all values of all words.

const
  alphabet = "abcdefghijklmnopqrstuvwxyz"

type
  Data = seq[string]

  XY = tuple[x, y: int]

  Dir = enum
    left, down, right, up

  Point = tuple
    pos: XY
    dir: Dir


proc parseData: Data =
  result = readInput().strip(chars = {'\n'}).split('\n')


func `[]`(data: Data, pt: Point): char =
  let (x, y) = pt.pos
  if y in 0..<data.len and x in 0..<data[0].len:
    result = data[y][x]
  else:
    result = ' '


func next(pt: Point): Point =
  result = pt
  case pt.dir
    of left:  result.pos.x.dec
    of right: result.pos.x.inc
    of up:    result.pos.y.dec
    of down:  result.pos.y.inc


func back(pt: Point): Point =
  result = pt
  case pt.dir
    of left:  result.dir = right
    of right: result.dir = left
    of up:    result.dir = down
    of down:  result.dir = up
  result = result.next


iterator neighbors(data: Data, pos: XY): Dir =
  for dir in Dir:
    if data[(pos, dir).next] != ' ':
      yield dir


func snakeEnds(data: Data): HashSet[Point] =
  for y, row in data:
    for x, c in row:
      if c == ' ': continue
      let pos = (x, y)
      let dirs = data.neighbors(pos).toSeq
      if dirs.len == 1:
        result.incl((pos, dirs[0]))


func followWord(data: Data, pt: Point): tuple[word: string, pt: Point, stop: bool] =
  var pt = pt
  while data[pt] != ' ':
    result.word &= data[pt]
    pt = pt.next
  pt = pt.back
  result.pt = pt
  let dirs = data.neighbors(pt.pos).toSeq
  if dirs.len == 1:
    assert dirs[0] == pt.dir
    result.stop = true
  else:
    assert dirs.len == 2
    result.pt.dir = dirs[1-dirs.find(pt.dir)]


func extractWords(data: Data): seq[string] =
  var ends = data.snakeEnds
  while ends.card > 0:
    var this = ends.pop
    while true:
      let (word, next, stop) = data.followWord(this)
      result.add(word)
      if stop:
        ends.excl(next)
        break
      this = next


func value(word: string): int =
  assert word.allIt(it in alphabet)
  result = word.mapIt(it.ord - 'a'.ord + 1).sum * word.len


let data = parseData()

benchmark:
  echo data.extractWords.map(value).sum

# 500135

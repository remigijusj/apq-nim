import std/[strutils]
import utils/common

# To encrypt, look down the left side for the current letter being encrypted and start moving right from that letter.
# Change direction by reflecting from the slashes as if they were mirrors.
# After each individual reflection in your path, change the orientation of the mirror you just bounced off -
# forward slashes become back slashes and vice versa.
# Follow the path until any letter is reached, which is the encrypted output of the input letter.
# Then, continue with encryption on the next letter (if any remain) using the map in its current, altered, state.
#
# Your map of mirrors is in the input below, use it to encrypt the word "FISSION_MAILED"
# The encrypted output string is the answer to this challenge.

type
  Data = seq[string]

  XY = tuple[x, y: int]

  Dir = enum
    right, down, left, up

  Vec = tuple
    pos: XY
    dir: Dir

const
  mirrors = "\\/"


proc parseData: Data =
  readInput().strip(chars = {'\n'}).split('\n')


func inside(this: Vec, hall: Data): bool =
  this.pos.x in 1..<(hall[0].len-1) and this.pos.y in 1..<(hall.len-1)


func `[]`(hall: Data, this: Vec): char =
  hall[this.pos.y][this.pos.x]


func `[]=`(hall: var Data, this: Vec, c: char) =
  hall[this.pos.y][this.pos.x] = c


proc advance(this: var Vec) =
  case this.dir
    of left:  this.pos.x.dec
    of right: this.pos.x.inc
    of up:    this.pos.y.dec
    of down:  this.pos.y.inc


proc rotate(this: var Vec, rot: range[0..1]) =
  if rot == 0: # \
    case this.dir
      of right: this.dir = down
      of down:  this.dir = right
      of left:  this.dir = up
      of up:    this.dir = left
  else: # /
    case this.dir
      of right: this.dir = up
      of down:  this.dir = left
      of left:  this.dir = down
      of up:    this.dir = right


func encrypt(hall: var Data, c: char): char =
  let y = hall.findIt(it[0] == c)
  assert y > 0
  var this: Vec = ((1, y), right)
  while this.inside(hall):
    let x = mirrors.find(hall[this])
    if x >= 0:
      this.rotate(x)
      hall[this] = mirrors[1-x]
    this.advance
  result = hall[this]


func encrypt(hall: var Data, input: string): string =
  for c in input:
    result.add hall.encrypt(c)


var data = parseData()

benchmark:
  echo data.encrypt("FISSION_MAILED")

# EZ3NHAZGBNOFIB

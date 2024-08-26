import std/[strutils,tables,heapqueue]
import utils/common

# Huffman decoder.
# The input to this puzzle is in two parts - the first line is a set of characters.
# Use these characters to follow the above rules to build the tree and obtain the Huffman code for each letter.
# The second line contains the answer to the challenge as Huffman coded bits, which should be decoded.

type
  Tree = ref object
    left, right: Tree
    data: char
    freq: int
    seqn: int


# In the case of a tie, new trees are inserted at the bottom/end of the group of their tied weights (last).
func `<`(a, b: Tree): bool =
  (a.freq < b.freq) or
  (a.freq == b.freq and a.seqn < b.seqn) or
  (a.freq == b.freq and a.seqn == b.seqn and a.data.ord < b.data.ord)


proc parseData: (string, string) =
  let parts = readInput().strip.split("\n")
  result = (parts[0], parts[1])


func buildTree(text: string): Tree =
  var list: seq[Tree]
  for data, freq in text.toCountTable:
    list.add Tree(data: data, freq: freq)

  var queue = list.toHeapQueue
  while queue.len > 1:
    let left = queue.pop
    let right = queue.pop
    var top = Tree(data: '\xFF', freq: left.freq + right.freq, seqn: list.len - queue.len)
    top.left = left
    top.right = right
    queue.push(top)

  result = queue.pop


func decode(root: Tree, bits: string): string =
  var this = root
  for c in bits:
    case c
      of '0': this = this.left
      of '1': this = this.right
      else: assert false

    if this.left == nil and this.right == nil: # leaf
      result &= this.data
      this = root

  assert this == root


let (text, bits) = parseData()

benchmark:
  echo buildTree(text).decode(bits)

# Some random characters: (]!~`^`.'+>'%"|.*:@)}?"^;;%#+-}#{-;+}>-=%:?->*$:<} The actual answer is: churlish

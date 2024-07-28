import std/[strutils,sequtils]
import bigints
import utils/common

type
  Data = seq[BigInt]

proc parseData: Data =
  readInput().strip.splitLines.mapIt(it.initBigInt)


let data = parseData()

benchmark:
  echo data.foldl(a * b, initBigInt(1))

# 15219490042476673293856415300433634433293774002195671040

import std/[times,monotimes]


proc readInput*(): string =
  result = readAll(stdin)


template benchmark*(code: untyped) =
  block:
    when defined(timing):
      let start = getMonoTime()
    code
    when defined(timing):
      let elapsed = getMonoTime() - start
      let ms = elapsed.inMilliseconds
      echo "Time: ", ms, "ms"


# often needed
func sum*[T](x: openArray[T]): T =
  for i in items(x): result = result + i

func prod*[T](x: openArray[T]): T =
  result = 1.T
  for i in items(x): result = result * i


template findIt*(data, pred: untyped): int =
  ## Return the index of the first element in "data" satisfying
  ## the predicate "pred" or -1 if no such element is found.
  var result = -1
  for i, it {.inject.} in data.pairs:
    if pred:
      result = i
      break
  result


func isqrt*(x: int): int =
  var q = 1
  while q <= x:
    q = q shl 2

  var z = x
  while q > 1:
    q = q shr 2
    let t = z - result - q
    result = result shr 1
    if t >= 0:
      z = t
      result += q

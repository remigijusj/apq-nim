import std/[strutils,sequtils,tables]
import utils/common

# A record appearing more than once means that everything between the first instance of that record 
# up to the latest occurrence was incorrect, and should be discarded. 
# Values after this occurrence are treated as if those records in between hadn't existed.
# What is the sum of the values returned from your input after this process has been applied?
#
# 1 4 3 2 4 7 2 6 3 6 -> 1 4 7 2 6
# . . x x x . . . x x

type
  Data = seq[int]

  Seen = Table[int, int]


proc parseData: Data =
  readInput().strip.split(" ").map(parseInt)


proc cleanupBigger(seen: var Seen, j: int) =
  for val, i in seen.mpairs:
    if i > j:
      seen[val] = -1


func filterCorrect(data: Data): Data =
  var seen: Seen
  for i, val in data:
    if val notin seen or seen[val] < 0:
      seen[val] = result.len
      result.add(val)
    else:
      let j = seen[val]
      result.setLen(j+1)
      seen.cleanupBigger(j)


let data = parseData()

benchmark:
  echo data.filterCorrect.sum

# 321

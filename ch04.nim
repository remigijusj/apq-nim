import std/[strutils]
import utils/common

# What is the sum of the positive co-primes of that number which are less than that number?
# https://math.stackexchange.com/questions/569210/sum-of-all-coprimes-of-a-number
#   S = phi(n) * n / 2

proc parseData: int =
  readInput().strip.parseInt


# https://www.geeksforgeeks.org/square-root-of-an-integer/
func floorSqrt(n: int): int =
  if n < 2:
    return n

  var i = 1
  var s = 1
  while s <= n:
    i += 1
    s = i * i

  return i - 1


# https://cp-algorithms.com/algebra/phi-function.html
func phi(n: int): int =
  var n = n
  result = n

  for i in 2..n.floorSqrt:
    if n mod i == 0:
      while n mod i == 0:
        n = n div i
      result.dec(result div i)

  if n > 1:
    result.dec(result div n)


func sumOfCoprimes(n: int): int =
  result = phi(n) * n div 2


let data = parseData()

benchmark:
  echo data.sumOfCoprimes

# 195153719200

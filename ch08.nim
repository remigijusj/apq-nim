import std/[strscans,strutils,sequtils]
from times import DateTime, parse, `+`, `-`, days
import utils/common

# Once per day, if you have enough of both, you use 100ml of milk and 100g of cereal.
# Milk always expires on the 5th day after you buy it, after you use it that morning,
#   and you always use your oldest unexpired milk to avoid waste.
# You always buy new milk after breakfast, and cereal before breakfast
# (i.e. never use milk as soon as you get it, but you can use cereal as soon as you get it
#   if you already have milk).

type
  Purchase = tuple
    date: DateTime
    milk, cereal: int

  Data = seq[Purchase]

  Food = tuple
    cereal: int
    milk: seq[int]


proc parsePurchase(line: string): Purchase =
  var date: string
  assert line.scanf("$+,$i,$i", date, result.milk, result.cereal)
  result.date = parse(date, "yyyy-MM-dd")


proc parseData: Data =
  readInput().strip.splitLines[1..^1].map(parsePurchase)


func findDay(list: seq[int]): int =
  for i in countdown(list.len-1, 0):
    if list[i] > 0:
      return i
  return -1


proc update(my: var Food, got: Purchase) =
  my.cereal += got.cereal
  let day = my.milk.findDay
  if my.cereal >= 100 and day >= 0:
    my.cereal -= 100
    my.milk[day] -= 100
  my.milk.insert(got.milk)
  my.milk.setLen(min(5, my.milk.len))


proc calcRemainder(data: Data): int =
  var food: Food
  var date = data[0].date - 1.days

  for i, purchase in data:
    assert purchase.milk mod 100 == 0
    assert purchase.date == date + 1.days
    date = purchase.date
    food.update(purchase)

  result = food.milk.sum + food.cereal


let data = parseData()

benchmark:
  echo data.calcRemainder

# 1100

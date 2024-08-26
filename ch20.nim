import std/[strutils]
import utils/common

# Your input is a set of decks of cards, shuffled together.
# Draw from this deck, in order, one card at a time.
# Any time you hit a total card value of 21, you win! Any time you go over 21 you lose.
# In either case, once a game is done, immediately start again with the next card,
# and repeat until there are no cards left.
# While playing you can consider aces to be 11 or 1 at any time,
# while 2 to 10 have their face value and Jack, Queen and King are worth 10.
# 
# How many games do you win with the input for this challenge?

const cards = "A23456789XJQK"

type
  Data = string


proc parseData: Data =
  readInput().strip.replace("10", "X").replace(" ")


func countWins(deck: Data): int =
  var total = 0
  var carry = 0

  for card in deck:
    assert card in cards
    case card
      of 'A':
        total += 1
        carry.inc
      of '2'..'9':
        total += (card.ord - '0'.ord)
      else:
        total += 10

    if total == 21 or (total == 11 and carry > 0):
      result.inc
      total = 0
      carry = 0
    elif total > 21:
      total = 0
      carry = 0


let data = parseData()

benchmark:
  echo data.countWins

# 256

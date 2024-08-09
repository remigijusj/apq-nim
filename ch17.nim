import std/[strutils,sequtils,tables]
from times import DateTime, parse, format, `-`, inDays
import utils/common

# We'll define shame as days on a goalless streak - any national team who plays an international game
# and finishes without scoring is in a state of shame, starting that day.
# The shame ends the day they score a goal in another international game.
# Which nation has the longest closed goalless streak, across which dates? (team startdate enddate)
# Any goalless streak currently running shouldn't be counted.

type
  Match = tuple
    date: DateTime
    home_team, away_team: string
    home_score, away_score: int
    tournament, city, country: string
    neutral: bool

  Data = seq[Match]

  Shame = object
    current: Table[string, DateTime] # team -> started
    past: CountTable[string] # output -> length


# 1872-11-30,Scotland,England,0,0,Friendly,Glasgow,Scotland,FALSE
proc parseMatch(line: string): Match =
  let it = line.split(',')
  result = (date: parse(it[0], "yyyy-MM-dd"),
    home_team: it[1], away_team: it[2],
    home_score: it[3].parseInt, away_score: it[4].parseInt,
    tournament: it[5], city: it[6], country: it[7],
    neutral: it[8] == "TRUE")


proc parseData: Data =
  readInput().strip.splitLines[1..^1].map(parseMatch)


proc update(shame: var Shame, today: DateTime, team: string, score: int) =
  if score == 0:
    discard shame.current.hasKeyOrPut(team, today)
  else:
    var started: DateTime
    if shame.current.pop(team, started):
      let key = team & " " & format(started, "yyyyMMdd") & " " & format(today, "yyyyMMdd")
      shame.past[key] = inDays(today - started)


# Format example: "Somaliland 19000103 19020101"
func longestShame(data: Data): string =
  var shame: Shame
  for match in data:
    shame.update(match.date, match.home_team, match.home_score)
    shame.update(match.date, match.away_team, match.away_score)
  result = shame.past.largest.key


let data = parseData()

benchmark:
  echo data.longestShame

# Kyrgyzstan 19560803 19920926

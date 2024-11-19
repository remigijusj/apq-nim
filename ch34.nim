import std/[strutils,sequtils,heapqueue]
import utils/common

# The outbound timetables look like a list of stations and the time each route arrives at that station.
# The station names seem to be set up so that trains always run from lower letters to higher letters.
# - ALL TRAINS MUST NOW REMAIN IN STATION FOR 5 MINUTES; TIMETABLES DO NOT YET REFLECT THIS
# - ONLY ONE TRAIN IN THE STATION AT A TIME
# - TRAINS FROM LOWER ALPHABETIC STATIONS HAVE QUEUE PRIORITY; OTHERWISE FIRST IN FIRST OUT
# - FOR SAFETY: ARRIVE -> QUEUE -> ENTER -> DEPART
# Note that some of these trains run close to midnight - assume these trains only set off once,
#   and no early runs the next day(s) affect your currently running trains.
# After running through all the routes, how long does the longest route take in minutes?

type
  Data = object
    trains: seq[string]
    stations: seq[string]
    arrivals: seq[seq[int]]

  RouteItem = tuple
    prev, next: int # station
    time: int

  Route = seq[RouteItem]

  Train = object
    prev, next: int # station
    timer, runtime: int
    finished: bool

  Station = object
    this: int # train
    queue: HeapQueue[(int, int, int)]


func parseValue(val: string): int =
  case val.len
    of 0: result = -1
    of 5: result = parseInt(val[0..1]) * 60 + parseInt(val[3..4])
    else: assert false


func parseStation(line: string): (string, seq[int]) =
  let values = line.split(',')
  result = (values[0], values[1..^1].map(parseValue))


proc parseData: Data =
  let lines = readInput().strip.split('\n')
  let header = lines[0].split(',')
  result.trains = header[1..^1]
  for line in lines[1..^1]:
    let (name, arrivals) = line.parseStation
    result.stations.add(name)
    result.arrivals.add(arrivals)
    assert arrivals.len == result.trains.len


func calcRoutes(data: Data): seq[Route] =
  result.setLen(data.trains.len)
  for si, arrivals in data.arrivals:
    for ti, this in arrivals:
      if this < 0: continue
      for sj in countdown(si-1, -1):
        let prev = if sj < 0: 0  else: data.arrivals[sj][ti]
        if prev >= 0:
          result[ti].add (sj, si, this - prev)
          break


func findNext(route: Route, this: int): int =
  for ri, item in route:
    if item.prev == this:
      return ri
  result = -1


proc updateTrains(routes: seq[Route], now: int, trains: var seq[Train], stations: var seq[Station]) =
  for ti, train in trains.mpairs:
    if train.timer < 0: continue # in queue or finished
    assert train.timer > 0
    train.timer.dec
    if train.timer > 0: continue

    if train.prev != train.next: # arrived, into queue
      train.timer = -1
      stations[train.next].queue.push (train.prev, now, ti)
    else:
      let ri = routes[ti].findNext(train.prev)
      stations[train.prev].this = -1
      if ri >= 0: # departed
        train.next = routes[ti][ri].next
        train.timer = routes[ti][ri].time
      else: # finished
        train.finished = true
        train.timer = -1
        train.runtime = now - routes[ti][0].time


proc updateStations(routes: seq[Route], now: int, trains: var seq[Train], stations: var seq[Station]) =
  for si, station in stations.mpairs:
    if station.this < 0 and station.queue.len > 0:
      let (_, _, ti) = station.queue.pop
      trains[ti].prev = trains[ti].next
      trains[ti].timer = 5
      station.this = ti


proc initState(routes: seq[Route], trains: var seq[Train], stations: var seq[Station]) =
  for ti, train in trains.mpairs:
    assert routes[ti].len > 0 and routes[ti].allIt(it.time > 0)
    let route0 = routes[ti][0]
    train.prev = route0.prev
    train.next = route0.next
    train.timer = route0.time

  for ti, station in stations.mpairs:
    station.this = -1


func longestRoute(data: Data): int =
  var trains = newSeq[Train](data.trains.len)
  var stations = newSeq[Station](data.stations.len)
  let routes = data.calcRoutes
  routes.initState(trains, stations)

  for now in 1..int.high:
    routes.updateTrains(now, trains, stations)
    routes.updateStations(now, trains, stations)
    if trains.allIt(it.finished): break

  assert stations.allIt(it.queue.len == 0)
  assert trains.allIt(it.runtime > 0)
  result = trains.mapIt(it.runtime).max


let data = parseData()

benchmark:
  echo data.longestRoute

# 2617

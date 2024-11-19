import std/[sequtils,deques]

# Find the lowest common ancestor in the blossom tree
proc lca(match: seq[int], base: seq[int], p: seq[int], a: int, b: int): int =
    var used = repeat(false, match.len)
    var a = a
    while true:
        a = base[a]
        used[a] = true
        if match[a] == -1:
            break
        a = p[match[a]]
    var b = b
    while true:
        b = base[b]
        if used[b]:
            return b
        b = p[match[b]]

# Mark the path from v to the base of the blossom
proc markPath(match: seq[int], base: seq[int], blossom: var seq[bool], p: var seq[int], v: int, b: int, children: int) =
    var v = v
    var children = children
    while base[v] != b:
        blossom[base[v]] = true
        blossom[base[match[v]]] = true
        p[v] = children
        children = match[v]
        v = p[match[v]]

# Finds path
proc findPath(graph: seq[seq[int]], match: seq[int], p: var seq[int], root: int): int =
    let n = graph.len
    var used = repeat(false, n)
    p = repeat(-1, n)
    var base = toSeq(0..<n)
    used[root] = true
    var q = [root].toDeque

    while q.len > 0:
        let v = q.popFirst
        for to in graph[v]:
            var to = to
            if base[v] == base[to] or match[v] == to:
                continue
            if to == root or (match[to] != -1 and p[match[to]] != -1):
                let curbase = lca(match, base, p, v, to)
                var blossom = repeat(false, n)
                markPath(match, base, blossom, p, v, curbase, to)
                markPath(match, base, blossom, p, to, curbase, v)
                for i in 0..<n:
                    if blossom[base[i]]:
                        base[i] = curbase
                        if not used[i]:
                            used[i] = true
                            q.addLast(i)
            elif p[to] == -1:
                p[to] = v
                if match[to] == -1:
                    return to
                to = match[to]
                used[to] = true
                q.addLast(to)
    return -1

# Blossom algorithm
proc maxMatching*(graph: seq[seq[int]]): seq[int] =
    let n = graph.len
    var match = repeat(-1, n)
    var p = repeat(0, n)
    for i in 0..<n:
        if match[i] == -1:
            var v = findPath(graph, match, p, i)
            while v != -1:
                let pv = p[v]
                let ppv = match[pv]
                match[v] = pv
                match[pv] = v
                v = ppv
    result = match

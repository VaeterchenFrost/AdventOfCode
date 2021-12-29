import numpy as np


def pathing(wam, visited, posi, end, twice=True):
    """
    wam: arraylike the W-Adj-M of the grid
    visited: [int] forbidden nodes
    posi: int current position
    end: int terminating node
    twice: bool if possible to visit twice
    """
    # print("p ", visited, posi)
    ways = np.copy(wam[::, posi])
    ends = ways[end]
    ways[end] = 0
    if not twice:
        ways[visited] = 0
    return ends + sum(
        [
            ways[x] * pathing(wam, visited + [x], x, end, twice and (x not in visited))
            for x in np.where(ways > 0)[0]
        ]
    )


# nodes = ["end", "start", "b", "c"]
# m = [[0, 1, 2, 1], [1, 0, 2, 1], [2, 2, 2, 1], [1, 1, 1, 1]]

nodes = ["we", "ys", "px", "yq", "pr", "wq", "start", "oe", "end"]
m = [
    [1, 1, 1, 1, 2, 0, 1, 1, 0],
    [1, 0, 1, 0, 1, 1, 1, 0, 1],
    [1, 1, 1, 2, 1, 0, 0, 1, 1],
    [1, 0, 2, 3, 2, 1, 0, 2, 0],
    [2, 1, 1, 2, 1, 1, 0, 2, 0],
    [0, 1, 0, 1, 1, 1, 1, 1, 0],
    [1, 1, 0, 0, 0, 1, 0, 0, 0],
    [1, 0, 1, 2, 2, 1, 0, 3, 1],
    [0, 1, 1, 0, 0, 0, 0, 1, 0],
]

wam = np.array(m)
wam[nodes.index("start")] = 0
wam[::, nodes.index("end")] = 0
# start = np.zeros(len(m), dtype=int)
# start[nodes.index("start")] = 1
# ways = np.dot(wam, start)
import time

start_time = time.perf_counter()
result = pathing(np.copy(wam), [], nodes.index("start"), nodes.index("end"), False)
end_time = time.perf_counter()
print("Part 1 ", round((end_time - start_time) * 1000, 3), "milliseconds")
print(result)
start_time = time.perf_counter()
result = pathing(np.copy(wam), [], nodes.index("start"), nodes.index("end"))
end_time = time.perf_counter()
print("Part 2 ", round((end_time - start_time) * 1000, 3), "milliseconds")
print(result)

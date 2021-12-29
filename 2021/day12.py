import numpy as np


def pathing(res, visited, posi, end):
    """
    res: arraylike the W-Adj-M of the grid
    visited: [int] forbidden nodes
    posi: int current position
    end: int terminating node
    """
    print("p ", visited, posi)
    ways = np.copy(res[::, posi])
    ends = ways[end]
    ways[end] = 0
    ways[visited] = 0
    return ends + sum(
        [ways[x] * pathing(res, visited + [x], x, end) for x in np.where(ways > 0)[0]]
    )


nodes=['we', 'ys', 'px', 'yq', 'pr', 'wq', 'start', 'oe', 'end']
m=[[1, 1, 1, 1, 2, 0, 1, 1, 0], [1, 0, 1, 0, 1, 1, 1, 0, 1], [1, 1, 1, 2, 1, 0, 0, 1, 1], [1, 0, 2, 3, 2, 1, 0, 2, 0], [2, 1, 1, 2, 1, 1, 0, 2, 0], [0, 1, 0, 1, 1, 1, 1, 1, 0], [1, 1, 0, 0, 0, 1, 0, 0, 0], [1, 0, 1, 2, 2, 1, 0, 3, 1], [0, 1, 1, 0, 0, 0, 0, 1, 0]]

wam = np.array(m)
wam[nodes.index("start")] = 0
wam[::, nodes.index("end")] = 0
# start = np.zeros(len(m), dtype=int)
# start[nodes.index("start")] = 1
# ways = np.dot(wam, start)
print(pathing(np.copy(wam), [], nodes.index("start"), nodes.index("end")))

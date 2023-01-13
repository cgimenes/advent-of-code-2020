def adjacent_indexes(index, limit):
    directions = [
        # Upper
        (0, 0, -1),
        (-1, -1, -1),
        (0, -1, -1),
        (1, -1, -1),
        (-1, 0, -1),
        (1, 0, -1),
        (-1, 1, -1),
        (0, 1, -1),
        (1, 1, -1),

        # Middle
        (-1, -1, 0),
        (0, -1, 0),
        (1, -1, 0),
        (-1, 0, 0),
        (1, 0, 0),
        (-1, 1, 0),
        (0, 1, 0),
        (1, 1, 0),

        # Bottom
        (0, 0, 1),
        (-1, -1, 1),
        (0, -1, 1),
        (1, -1, 1),
        (-1, 0, 1),
        (1, 0, 1),
        (-1, 1, 1),
        (0, 1, 1),
        (1, 1, 1),
    ]

    result = []
    for direction in directions:
        x = index[0] + direction[0]
        y = index[1] + direction[1]
        z = index[2] + direction[2]
        if 0 <= x < limit and 0 <= y < limit and 0 <= z < limit:
            result.append((x, y, z))
    return result

def apply(cells, limit, check_cell):
    result = list(map(lambda y: list(map(lambda x: list(x), y)), cells))
    for z in range(0, limit):
        for y in range(0, limit):
            for x in range(0, limit):
                result[z][y][x] = check_cell((x, y, z), limit, cells)

    return list(map(lambda y: list(map(lambda x: "".join(x), y)), result))

def active(cells, indexes):
    adj_active = 0
    for adj_index in indexes:
        adj_cell = cells[adj_index[2]][adj_index[1]][adj_index[0]]
        if adj_cell == '#':
            adj_active += 1
    return adj_active

def count_active_cells(cells, limit):
    count = 0
    for z in range(0, limit):
        for y in range(0, limit):
            for x in range(0, limit):
                cell = cells[z][y][x]
                if cell == '#':
                    count += 1
    return count

def do(cells, check_cell):
    limit = len(cells)
    last = apply(cells, limit, check_cell)
    while True:
        current = apply(last, limit, check_cell)
        if last == current:
            break
        last = current
        limit += 2
    return count_active_cells(current, limit)

def check_adjacent_cell(index, limit, cells):
    cell = cells[index[2]][index[1]][index[0]]
    adj_indexes = adjacent_indexes(index, limit)
    adj_active = active(cells, adj_indexes)

    if cell == '#' and adj_active in [2, 3]:
        return '#'
    elif cell == '.' and adj_active == 3:
        return '#'
    else:
        return '.'

with open('test', 'r') as f:
    lines = f.readlines()


cells = []
for y in range(0, len(lines)):
    cells.append(list(map(lambda l: l.rstrip(), lines)))

answer_1 = do(cells, check_adjacent_cell)

# print('Part 1: %s' % answer_1)

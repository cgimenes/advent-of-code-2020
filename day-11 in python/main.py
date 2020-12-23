def in_sight_indexes(index, seats, limits):
    directions = [
        (-1, -1),
        (0, -1),
        (1, -1),
        (-1, 0),
        (1, 0),
        (-1, 1),
        (0, 1),
        (1, 1)
    ]

    result = []
    for direction in directions:
        x = index[0]
        y = index[1]
        while True:
            x += direction[0]
            y += direction[1]
            if x >= limits[0] or y >= limits[1] or x < 0 or y < 0:
                break
            if seats[y][x] != '.':
                result.append((x, y))
                break
    return result

def adjacent_indexes(index, limits):
    directions = [
        (-1, -1),
        (0, -1),
        (1, -1),
        (-1, 0),
        (1, 0),
        (-1, 1),
        (0, 1),
        (1, 1)
    ]

    result = []
    for direction in directions:
        x = index[0] + direction[0]
        y = index[1] + direction[1]
        if 0 <= x < limits[0] and 0 <= y < limits[1]:
            result.append((x, y))
    return result

def apply(seats, limits, check_seat):
    result = list(map(lambda l: list(l), seats))
    for y in range(0, limits[1]):
        for x in range(0, limits[0]):
            result[y][x] = check_seat((x, y), limits, seats)

    return list(map(lambda l: "".join(l), result))

def occupied(seats, indexes):
    adj_occupied = 0
    for adj_index in indexes:
        adj_seat = seats[adj_index[1]][adj_index[0]]
        if adj_seat == '#':
            adj_occupied += 1
    return adj_occupied

def count_occupied_seats(seats, limits):
    count = 0
    for y in range(0, limits[1]):
        for x in range(0, limits[0]):
            seat = seats[y][x]
            if seat == '#':
                count += 1
    return count

def do(seats, limits, check_seat):
    last = apply(seats, limits, check_seat)
    while True:
        current = apply(last, limits, check_seat)
        if last == current:
            break
        last = current
    return count_occupied_seats(current, limits)

def check_adjacent_seat(index, limits, seats):
    seat = seats[index[1]][index[0]]
    adj_indexes = adjacent_indexes(index, limits)
    adj_occupied = occupied(seats, adj_indexes)

    if seat == 'L' and adj_occupied == 0:
        return '#'
    elif seat == '#' and adj_occupied >= 4:
        return 'L'
    else:
        return seat

def check_seat_in_sight(index, limits, seats):
    seat = seats[index[1]][index[0]]
    adj_indexes = in_sight_indexes(index, seats, limits)
    adj_occupied = occupied(seats, adj_indexes)

    if seat == 'L' and adj_occupied == 0:
        return '#'
    elif seat == '#' and adj_occupied >= 5:
        return 'L'
    else:
        return seat

with open('input', 'r') as f:
    lines = f.readlines()
seats = list(map(lambda l: l.rstrip(), lines))
limits = (len(seats[0]), len(seats))

answer_1 = do(seats, limits, check_adjacent_seat)
answer_2 = do(seats, limits, check_seat_in_sight)

print('Part 1: %s' % answer_1)
print('Part 2: %s' % answer_2)

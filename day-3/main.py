def find_trees(lines, right_count, down_count):
    tree_count = 0
    x = 0
    y = 0
    col_size = len(lines[0].strip())

    while y < len(lines) - 1:
        x = (x + right_count) % col_size
        y += down_count
        line = lines[y].strip()
        if line[x] == '#':
            tree_count += 1

    return tree_count


with open('input', 'r') as f:
    lines = f.readlines()

answer_1 = find_trees(lines, 3, 1)

answer_2 = find_trees(lines, 1, 1)\
           * find_trees(lines, 3, 1)\
           * find_trees(lines, 5, 1)\
           * find_trees(lines, 7, 1)\
           * find_trees(lines, 1, 2)

print('Part 1: %s' % answer_1)
print('Part 2: %s' % answer_2)

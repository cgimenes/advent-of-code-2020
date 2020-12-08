def parse_and_check
  valid_count = 0
  File.foreach('input') do |line|
    splitted = line.split(' ')
    bounds = splitted[0].split('-')
    lower_bound = bounds[0].to_i
    upper_bound = bounds[1].to_i
    letter = splitted[1][0]
    password = splitted[2]

    valid_count += 1 if yield lower_bound, upper_bound, letter, password
  end
  valid_count
end

answer_1 = parse_and_check do |lb, ub, l, p|
  p.tr("^#{l}", '').size.between?(lb, ub)
end

answer_2 = parse_and_check do |lb, ub, l, p|
  (p[lb-1] == l) ^ (p[ub-1] == l)
end

puts "Part 1: #{answer_1}"
puts "Part 2: #{answer_2}"

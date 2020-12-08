require 'parslet'
require './dsl'

def part_1(tree)
  bags = []
  queue = ['shiny gold']
  until queue.empty?
    identifier = queue.pop
    tree.each do |bag|
      bag[:content].each do |bagc|
        if bagc[:identifier] == identifier
          bags.push bag[:identifier]
          queue.unshift bag[:identifier]
        end
      end
    end
  end
  bags.uniq.count
end

def part_2(identifier, tree)
  count = 0
  found = tree.find { |bag| bag[:identifier] == identifier }
  found[:content].each do |bag|
    count += bag[:quantity] + bag[:quantity] * part_2(bag[:identifier], tree)
  end
  count
end

file_content = File.open("input").read
parser = DslParser.new
transform = DslTransform.new
tree = transform.apply parser.parse(file_content)

answer_1 = part_1 tree
answer_2 = part_2 'shiny gold', tree

puts "Part 1: #{answer_1}"
puts "Part 2: #{answer_2}"

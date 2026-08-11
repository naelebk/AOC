#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

LIMIT = 100_000

def build_tree(lines, index)
  node = { children: {}, files: {} }
  while index < lines.length
    line = lines[index]
    if line[0] == '$' && line[1] == 'cd'
      dir = line[2]
      if dir == '..'
        index += 1
        return [node, index]
      else
        child, index = build_tree(lines, index + 1)
        node[:children][dir] = child
      end
    elsif line[0] == '$' && line[1] == 'ls'
      index += 1
    elsif line[0] == 'dir'
      index += 1
    else
      size, name = line
      node[:files][name] = size.to_i
      index += 1
    end
  end
  [node, index]
end

def sum_below_limit(node, limit)
  total = 0
  compute = lambda do |n|
    size = n[:files].values.sum
    size += n[:children].values.sum { |child| compute.call(child) }
    total += size if size <= limit
    size
  end
  compute.call(node)
  total
end

Utils.time {
  YEAR = 2022
  DAY = 7
  LEVEL = 1

  input = Utils.read_lines("day07-input.txt").map(&:split)
  node, _ = build_tree(input, 1)

  sum = sum_below_limit(node, LIMIT)
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.83153417 secondes

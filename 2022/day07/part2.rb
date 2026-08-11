#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

LIMIT = 100_000
SPACE_AVAILABLE = 70000000
UNUSED_SPACE_NEEDED = 30000000

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

def node_size(node)
  size = node[:files].values.sum
  size += node[:children].values.sum { |child| node_size(child) }
  size
end

def collect_sizes(node, sizes = [])
  sizes << node_size(node)
  node[:children].each_value { |child| collect_sizes(child, sizes) }
  sizes
end

Utils.time {
  YEAR = 2022
  DAY = 7
  LEVEL = 2

  input = Utils.read_lines("day07-input.txt").map(&:split)
  node, _ = build_tree(input, 1)

  used_space = node_size(node)
  free_space = SPACE_AVAILABLE - used_space
  space_to_free = UNUSED_SPACE_NEEDED - free_space

  sizes = collect_sizes(node)
  sum = sizes.select { |s| s >= space_to_free }.min
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.859294589 secondes
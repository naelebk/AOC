#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

DIRECTIONS = {
  RIGHT: [0, 1],
  DOWN: [1, 0],
  LEFT: [0, -1],
  UP: [-1, 0],
}

def change_direction(current_direction)
  keys = DIRECTIONS.keys
  next_index = (keys.index(current_direction) + 1) % keys.size
  keys[next_index]
end

def count_positions(grid)
  row, col = Utils.find_in_grid('^', grid)
  return 0 if row.nil? || col.nil?
  height, width = Utils.get_size_of_grid(grid)
  current_direction = :UP
  visited = Set.new
  loop do
    visited.add([row, col])
    drow, dcol = DIRECTIONS[current_direction]
    next_r = row + drow
    next_c = col + dcol
    break unless next_r.between?(0, height - 1) && next_c.between?(0, width - 1)
    if grid[next_r][next_c] == '#'
      current_direction = change_direction(current_direction)
    else
      row = next_r
      col = next_c
    end
  end
  visited.size
end

Utils.time {
  YEAR = 2024
  DAY = 06
  LEVEL = 1

  input = Utils.read_matrix('day06-input.txt')
  sum = count_positions(input)

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.78239334 secondes

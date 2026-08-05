#!/usr/bin/env ruby
# part2.rb
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

def count_obstructions(grid)
  start_row, start_col = Utils.find_in_grid('^', grid)
  return 0 if start_row.nil? || start_col.nil?
  height, width = Utils.get_size_of_grid(grid)
  visited_path = Set.new
  row, col = start_row, start_col
  current_direction = :UP
  
  loop do
    visited_path.add([row, col])
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
  
  count = 0
  visited_path.each do |test_row, test_col|
    next if test_row == start_row && test_col == start_col
    row, col = start_row, start_col
    current_direction = :UP
    visited_states = Set.new
    
    loop do
      state = [row, col, current_direction]
      if visited_states.include?(state)
        count += 1
        break
      end
      visited_states.add(state)
      drow, dcol = DIRECTIONS[current_direction]
      next_r = row + drow
      next_c = col + dcol
      
      break unless next_r.between?(0, height - 1) && next_c.between?(0, width - 1)
      
      if grid[next_r][next_c] == '#' || (next_r == test_row && next_c == test_col)
        current_direction = change_direction(current_direction)
      else
        row = next_r
        col = next_c
      end
    end
  end  
  count
end

Utils.time {
  YEAR = 2024
  DAY = 06
  LEVEL = 2

  input = Utils.read_lines('day06-sample-input.txt')
  sum = count_obstructions(input)

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 15.742244659 secondes

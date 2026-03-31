#!/usr/bin/env ruby 
# part1.rb
require_relative '../../utils.rb'

def slides_rocks_to_north(matrix, rows, cols)
  grid = Utils.deep_clone(matrix)
  cols.times do |j|
    available_row = 0
    rows.times do |i|
      case grid[i][j]
      when 'O'
        if i != available_row
          grid[available_row][j] = 'O'
          grid[i][j] = '.'
        end
        available_row += 1
      when '#'
        available_row = i + 1
      end
    end
  end
  grid
end

def calculate_total_load(matrix, rows)
  sum = 0
  matrix.each_with_index { |row, i|
    sum += (rows - i) * row.count { |el| el == 'O' }
  }
  sum
end

def rotate_90_clockwise(matrix)
  matrix.transpose.map(&:reverse)
end

def perform_spin_cycle(grid, rows, cols, target)
  history = {}
  results = {}

  (1..target).each do |step|
    4.times do
      grid = slides_rocks_to_north(grid, rows, cols)
      grid = rotate_90_clockwise(grid)
    end

    state = grid.map(&:join).join
    if history[state]
      start_step = history[state]
      loop_len = step - start_step
      final_step = start_step + (target - start_step) % loop_len
      return results[final_step]
    end
    history[state] = step
    results[step] = calculate_total_load(grid, rows)
  end
  results[target]
end


Utils.time {
  YEAR = 2023
  DAY = 14
  LEVEL = 2

  input = Utils.read_matrix('day14-input.txt')
  rows, cols = Utils.get_size_of_grid(input)
  nb_cycles = 10 ** 9 # 1 000 000 000 (1 milliard)
  sum = perform_spin_cycle(input, rows, cols, nb_cycles)
  
  puts sum
  
  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 2.894742331 secondes

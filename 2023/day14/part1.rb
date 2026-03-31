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


Utils.time {
  YEAR = 2023
  DAY = 14
  LEVEL = 1

  input = Utils.read_matrix('day14-input.txt')
  rows, cols = Utils.get_size_of_grid(input)
  slide_matrix = slides_rocks_to_north(input, rows, cols)
  sum = calculate_total_load(slide_matrix, rows)
  
  puts sum
  
  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.434830052 secondes

#!/usr/bin/env ruby 
# part2.rb
require_relative '../../utils.rb'

Utils.time {
  YEAR = 2023
  DAY = 3
  LEVEL = 2

  grid = Utils.read_matrix('day3-input.txt')
  width = grid.size
  height = grid[0].size
  sum = 0
  grid.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      next unless cell == "*"
      numbers = []
      Utils.neighbors8(x, y).each do |nx, ny|
        next unless Utils.in_bounds?(nx, ny, width, height)
        next unless Utils.is_digit?(grid[ny][nx])
        number = Utils.extract_number_from_coordinate_in_grid(grid, nx, ny)
        numbers << number unless numbers.include?(number)
      end
      sum += numbers[0] * numbers[1] if numbers.size == 2
    end
  end

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}

# Execution: 0.712140953 secondes

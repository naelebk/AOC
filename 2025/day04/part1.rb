#!/usr/bin/env ruby 
# part1.rb
require_relative '../../utils.rb'

Utils.time {
  YEAR = 2025
  DAY = 4
  LEVEL = 1

  grid = Utils.read_matrix('day4-input.txt')
  height, width = Utils.get_size_of_grid(grid)
  sum = 0
  grid.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      next unless cell == "@"
      neighbors_count = Utils.neighbors8(x, y).count do |nx, ny|
        Utils.in_bounds?(nx, ny, width, height) && grid[ny][nx] == "@"
      end
      sum += 1 if neighbors_count < 4
    end
  end
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}

# Execution: 0.573043609 secondes

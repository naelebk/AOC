#!/usr/bin/env ruby 
# part2.rb
require_relative '../../utils.rb'

Utils.time {
  YEAR = 2025
  DAY = 4
  LEVEL = 2

  grid = Utils.read_matrix('day4-input.txt')
  height = grid.size
  width = grid[0].size
  sum = 0
  loop do
    accessible = []
    grid.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        next unless cell == "@"        
        neighbors_count = Utils.neighbors8(x, y).count do |nx, ny|
          Utils.in_bounds?(nx, ny, width, height) && grid[ny][nx] == "@"
        end        
        accessible << [x, y] if neighbors_count < 4
      end
    end
    break if accessible.empty?
    accessible.each do |x, y|
      grid[y][x] = "."
    end    
    sum += accessible.size
  end

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}

# Execution: 1.802714062 secondes

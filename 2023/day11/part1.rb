#!/usr/bin/env ruby 
# part1.rb
require_relative '../../utils.rb'

def lines_and_columns_with_no_galaxies(grid)
  height, width = Utils.get_size_of_grid(grid)
  columns = {}
  lines = {}
  (1..height).each { |h| lines[h] = false }
  (1..width).each { |w| columns[w] = false }

  grid.each_with_index do |line, i|
    line.each_with_index do |element, j|
      if element == '#'
        columns[j+1] = true
        lines[i+1] = true
      end
    end
  end

  columns = columns.reject { |_, v| v }.keys
  lines = lines.reject { |_, v| v }.keys
  [columns, lines, grid]
end

def get_new_grid(grid, columns, lines)
  new_grid = grid.map(&:dup)
  width = new_grid.first.size

  lines.sort.each_with_index do |row, idx|
    new_grid.insert(row - 1 + idx, Array.new(width, "."))
  end

  new_grid = new_grid.transpose
  height   = new_grid.first.size

  columns.sort.each_with_index do |col, idx|
    new_grid.insert(col - 1 + idx, Array.new(height, "."))
  end

  new_grid.transpose
end

def calculate_all_paths(grid, columns, lines)
  new_grid = get_new_grid(grid, columns, lines)

  galaxies = []
  new_grid.each_with_index do |row, i|
    row.each_with_index do |cell, j|
      galaxies << [i, j] if cell == '#'
    end
  end

  galaxies.combination(2).sum do |(r1, c1), (r2, c2)|
    Utils.manhattan([r1, c1], [r2, c2])
  end
end

Utils.time {
  YEAR = 2023
  DAY = 11
  LEVEL = 1
  input = Utils.read_matrix('day11-input.txt')

  columns, lines, grid = lines_and_columns_with_no_galaxies(input)
  sum = calculate_all_paths(grid, columns, lines)
  
  puts sum
  
  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.350376127 secondes
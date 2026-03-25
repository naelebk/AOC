#!/usr/bin/env ruby 
# part2.rb
require_relative '../../utils.rb'

def lines_and_columns_with_no_galaxies(grid)
  height, width = Utils.get_size_of_grid(grid)
  columns = {}
  lines = {}
  (1..height).each { |h| lines[h] = false }
  (1..width).each { |w| columns[w] = false }

  grid.each_with_index do |row, i|
    row.each_with_index do |cell, j|
      if cell == '#'
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
  lines.each do |r| new_grid[r-1] = Array.new(new_grid[0].size, "!") end
  columns.each do |c| 
    new_grid.each { |row| row[c-1] = "?" if row[c-1] == "." }
  end
  new_grid
end

def calculate_all_paths(grid, columns, lines)
  new_grid = get_new_grid(grid, columns, lines)
  expansion_value = 1_000_000 # 1 million

  galaxies = []
  new_grid.each_with_index do |row, i|
    row.each_with_index do |cell, j|
      galaxies << [i, j] if cell == '#'
    end
  end

  galaxies.combination(2).sum do |(r1, c1), (r2, c2)|
    row_range = [r1, r2].min..[r1, r2].max
    col_range = [c1, c2].min..[c1, c2].max
    # marqueurs qu'il y a sur le chemin vertical
    v_expansion_steps = row_range.count { |r| new_grid[r][c1] == '!' }
    # marqueurs qu'il y a sur le chemin horizontal
    h_expansion_steps = col_range.count { |c| new_grid[r1][c] == '?' }
    # --------------------------------------------
    base_dist = Utils.manhattan([r1, c1], [r2, c2])
    total_expansion = (v_expansion_steps + h_expansion_steps) * (expansion_value - 1)
    base_dist + total_expansion
  end
end

Utils.time {
  YEAR = 2023
  DAY = 11
  LEVEL = 2

  input = Utils.read_matrix('day11-input.txt')
  columns, lines, grid = lines_and_columns_with_no_galaxies(input)
  sum = calculate_all_paths(grid, columns, lines)
  
  puts sum
  
  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 1.334160143 secondes

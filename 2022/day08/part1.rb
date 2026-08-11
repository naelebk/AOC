#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

def is_tree_visible?(tree, grid, height, width, y, x, directions)
  directions.any? do |dy, dx|
    if dy == 0 # droite ou gauche
      if dx < 0 # gauche
        grid[y][0...x].all? { |value| value < tree }
      else # droite
        grid[y][(x+1)...width].all? { |value| value < tree }
      end
    elsif dx == 0 # haut ou bas
      if dy < 0 # haut
        grid[0...y].map { |row| row[x] }.all? { |value| value < tree }
      else # bas
        grid[(y+1)...height].map { |row| row[x] }.all? { |value| value < tree }
      end
    end
  end
end

Utils.time {
  YEAR = 2022
  DAY = 8
  LEVEL = 1

  grid = Utils.read_matrix("day08-input.txt").map { |array| array.map(&:to_i) }
  height, width = Utils.get_size_of_grid(grid)
  directions = Utils.neighbors4(0,0).map {|y,x| [y*height, x*width] }
  sum = 0
  grid.each_with_index do |row, y|
    row.each_with_index do |tree, x|
      sum += 1 if is_tree_visible?(tree, grid, height, width, y, x, directions)
    end
  end

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.99981885 secondes

#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

def count_tree_visible(tree, grid, height, width, y, x, directions)
  trees = []
  directions.each do |dy, dx|
    if dy == 0 # droite ou gauche
      to_see = dx < 0 ? grid[y][0...x].reverse : grid[y][(x+1)...width]
    elsif dx == 0 # haut ou bas
      to_see = dy < 0 ? grid[0...y].map { |row| row[x] }.reverse : grid[(y+1)...height].map { |row| row[x] }
    end
    blocked_at = to_see.find_index { |value| value >= tree }
    trees.push(blocked_at.nil? ? to_see.size : blocked_at + 1)
  end
  trees.reduce(:*)
end

Utils.time {
  YEAR = 2022
  DAY = 8
  LEVEL = 2

  grid = Utils.read_matrix("day08-input.txt").map { |array| array.map(&:to_i) }
  height, width = Utils.get_size_of_grid(grid)
  directions = Utils.neighbors4(0,0).map {|y,x| [y*height, x*width] }
  sum = 0
  grid.each_with_index do |row, y|
    row.each_with_index do |tree, x|
      sum = [count_tree_visible(tree, grid, height, width, y, x, directions), sum].max
    end
  end

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.817854751 secondes

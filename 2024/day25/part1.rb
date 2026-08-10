#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

def heights(grille) = (0...grille[0].size).map { |col| grille.count { |ligne| ligne[col] == "#" } - 1 }

def overlap?(grid, keys)
  return 0 unless grid[0].all? { |c| c == "#" }
  h_max = grid.size - 2
  serrure = heights(grid)
  keys.count { |cle| serrure.each_index.all? { |i| serrure[i] + cle[i] <= h_max } }
end

Utils.time {
  YEAR = 2024
  DAY = 25
  LEVEL = 1

  grids = Utils.read_blocks('day25-input.txt').map{ |array| array.map(&:chars) }
  keys = grids.select { |g| g[0].all? { |c| c == "." } }.map { |g| heights(g) }

  sum = grids.sum { |grid| overlap?(grid, keys) }
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.709165942 secondes

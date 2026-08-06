#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

def total_price(grid)
  height, width = Utils.get_size_of_grid(grid)
  visited = Set.new
  total = 0
  (0...height).each do |y|
    (0...width).each do |x|
      next if visited.include?([x, y])
      plant = grid[y][x]

      passable = ->(cell) { cell == plant }
      region = Utils.flood_fill(grid, [x, y], passable: passable)   
      region.each { |pos| visited << pos }
      
      total += region.size * count_sides(region)
    end
  end
  total
end

def count_sides(region)
  region.sum { |x, y| count_corners_for_cell(x, y, region) }
end

def count_corners_for_cell(x, y, region)
  corners = 0
  [[-1, -1], [1, -1], [1, 1], [-1, 1]].each do |dx, dy| # diagonales
    horizontal = region.include?([x + dx, y])
    vertical = region.include?([x, y + dy])
    diagonal = region.include?([x + dx, y + dy])
    # corner convexe (les deux voisins orthogonaux sont dehors)
    corners += 1 if !horizontal && !vertical 
    # corner concave (les deux voisins orthogonaux sont dedans mais pas la diagonale)
    corners += 1 if horizontal && vertical && !diagonal
  end  
  corners
end

Utils.time {
  YEAR = 2024
  DAY = 12
  LEVEL = 2

  grid = Utils.read_matrix('day12-input.txt')
  sum = total_price(grid)
  
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 1.029964751 secondes

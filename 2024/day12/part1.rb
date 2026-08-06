#!/usr/bin/env ruby
# part1.rb
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

      total += region.size * calculate_perimeter(region)
    end
  end  
  total
end

def calculate_perimeter(region)
  perimeter = 0
  region.each do |x, y|
    Utils.neighbors4(x, y).each do |nx, ny|
      perimeter += 1 unless region.include?([nx, ny])
    end
  end
  perimeter
end

Utils.time {
  YEAR = 2024
  DAY = 12
  LEVEL = 1

  grid = Utils.read_matrix('day12-input.txt')
  sum = total_price(grid)
  
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.687141513 secondes

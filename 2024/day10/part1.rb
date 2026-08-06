#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

START = 0
FINAL = 9
DIRECTIONS = Utils.neighbors4(0,0)

def count_score(grid, x, y, current, nines = Set.new)
  height, width = Utils.get_size_of_grid(grid)
  return nines if x < 0 || x >= width || y < 0 || y >= height
  return nines if grid[y][x] != current
  if current == FINAL
    nines.add([x, y])
    return nines
  end
  DIRECTIONS.each { |dx, dy| count_score(grid, x + dx, y + dy, current + 1, nines) }
  nines
end



Utils.time {
  YEAR = 2024
  DAY = 10
  LEVEL = 1

  grid = Utils.read_matrix('day10-input.txt').map do |array|
    array.map(&:to_i)
  end
  sum = 0
  height, width = Utils.get_size_of_grid(grid)
  (0...height).each do |y|
    (0...width).each do |x|
      if grid[y][x] == START
        sum += count_score(grid, x, y, START).size
      end
    end
  end

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.780141377 secondes

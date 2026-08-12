#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

def build_grid(input, source = [500, 0])
  points = input.flatten(1) + [source]
  min_x, max_x = points.map(&:first).minmax
  max_y = points.map(&:last).max
  grid = Array.new(max_y + 1) { Array.new(max_x - min_x + 1, '.') }
  input.each do |path|
    path.each_cons(2) do |(x1, y1), (x2, y2)|
      if y1 == y2
        lo, hi = [x1, x2].minmax
        (lo..hi).each { |x| grid[y1][x - min_x] = '#' }
      else
        lo, hi = [y1, y2].minmax
        (lo..hi).each { |y| grid[y][x1 - min_x] = '#' }
      end
    end
  end
  grid[source[1]][source[0] - min_x] = '+'
  grid
end

def drop_one(grid, start_y, start_x)
  y = start_y
  x = start_x
  loop do
    return nil if y + 1 >= grid.size
    return nil if x - 1 < 0 || x + 1 >= grid[y + 1].size
    if grid[y + 1][x] == '.'
      y += 1
    elsif grid[y + 1][x - 1] == '.'
      y += 1
      x -= 1
    elsif grid[y + 1][x + 1] == '.'
      y += 1
      x += 1
    else
      return [y, x]
    end
  end
end

def pour_sand(grid)
  src_y, src_x = Utils.find_in_grid("+", grid)
  count = 0
  loop do
    pos = drop_one(grid, src_y, src_x)
    break if pos.nil?
    grid[pos[0]][pos[1]] = 'o'
    count += 1
  end
  count
end


Utils.time {
  YEAR = 2022
  DAY = 14
  LEVEL = 1

  input = Utils.read_csv("day14-input.txt", "->").map do |array|
    array.map { |value| value.strip.split(",").map(&:to_i) }
  end
  grid = build_grid(input)
  sum = pour_sand(grid)
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.012023008 secondes

#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

def count_reachable_infinite(grid, start_x, start_y, steps)
  height, width = Utils.get_size_of_grid(grid)
  visited = {}
  queue = [[start_x, start_y, 0]]
  visited[[start_x, start_y]] = 0
  while queue.any?
    x, y, dist = queue.shift
    next if dist + 1 > steps
    Utils.neighbors4(x, y).each do |nx, ny|
      nx_mod = nx % height
      ny_mod = ny % width
      next if grid[nx_mod][ny_mod] == '#'
      next if visited.key?([nx, ny])
      visited[[nx, ny]] = dist + 1
      queue.push([nx, ny, dist + 1])
    end
  end
  visited.count do |pos, d| d % 2 == steps % 2 end
end

def quadratic_interpolate(x1, y1, x2, y2, x3, y3, x)
  # On a trois points (x1, y1), (x2, y2), (x3, y3), pour trouver ax^2 + bx + c
  # Sources : https://www.geeksforgeeks.org/maths/quadratic-interpolation/
  d = (x1 - x2) * (x1 - x3) * (x2 - x3)
  a = Rational(y1 * (x2 - x3) + y2 * (x3 - x1) + y3 * (x1 - x2), d)
  b = Rational(y1 * (x3**2 - x2**2) + y2 * (x1**2 - x3**2) + y3 * (x2**2 - x1**2), d)
  c = Rational(y1 * x2 * x3 * (x2 - x3) + y2 * x3 * x1 * (x3 - x1) + y3 * x1 * x2 * (x1 - x2), d)
  (a * x**2 + b * x + c).round
end

Utils.time {
  YEAR = 2023
  DAY = 21
  LEVEL = 2

  grid = Utils.read_lines('day21-input.txt').map(&:chars)
  start_x, start_y = Utils.find_in_grid('S', grid)
  height, width = Utils.get_size_of_grid(grid)
  # 26501365 = 202300 * 131 + 65
  n = (26501365 - (height / 2)) / height
  # On calcule pour 3 valeurs différentes
  steps1 = height / 2
  steps2 = height / 2 + height
  steps3 = height / 2 + 2 * height

  count1 = count_reachable_infinite(grid, start_x, start_y, steps1)
  count2 = count_reachable_infinite(grid, start_x, start_y, steps2)
  count3 = count_reachable_infinite(grid, start_x, start_y, steps3)

  sum = quadratic_interpolate(0, count1, 1, count2, 2, count3, n)

  puts sum
  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 1.020298568 secondes
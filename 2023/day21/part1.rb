#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

def count_reachable(grid, start_x, start_y, steps)
  height, width = Utils.get_size_of_grid(grid)
  visited = {}
  queue = [[start_x, start_y, 0]]
  visited[[start_x, start_y]] = 0
  while queue.any?
    x, y, dist = queue.shift
    Utils.neighbors4(x, y).each do |nx, ny|
      next if nx < 0 || nx >= height || ny < 0 || ny >= width
      next if grid[nx][ny] == '#'
      next if dist + 1 > steps
      if !visited[[nx, ny]] || visited[[nx, ny]] > dist + 1
        visited[[nx, ny]] = dist + 1
        queue.push([nx, ny, dist + 1])
      end
    end
  end
  visited.count do |pos, d| d % 2 == steps % 2 end
end

Utils.time {
  YEAR = 2023
  DAY = 21
  LEVEL = 1

  grid = Utils.read_lines('day21-input.txt').map(&:chars)
  x, y = Utils.find_in_grid('S', grid)
  sum = count_reachable(grid, x, y, 64)

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.44344522 secondes

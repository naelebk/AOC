#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

# Approche de base naïve trop coûteuse et bancale :
# (goto emplacement)
# default_picoseconds, _ = Utils.bfs_grid_path(grid, start, finish, diagonal: false)
# new_grid = grid.dup
# visited = Set.new
# sum = 0
# grid.each_with_index do |row, y|
#   row.each_with_index do |element, x|
#     next if element != '#'
#     next if visited.include?([x, y])
#     Utils.neighbors4(0, 0).each do |dy, dx|
#       nx, ny = x + dx, y + dy
#       next unless Utils.in_bounds?(nx, ny, width, height)
#       next if visited.include?([nx, ny])
#       next unless grid[ny][nx] == '#'
#       visited.add([x, y])
#       visited.add([nx, ny])
#       new_grid = grid.dup
#       new_grid[y][x] = '.'
#       new_grid[ny][nx] = '.'
#       new_picoseconds, _ = Utils.bfs_grid_path(new_grid, start, finish, diagonal: false)
#       sum += 1 if default_picoseconds - new_picoseconds >= 100
#       new_grid = grid.dup
#       break
#     end
#   end
# end

# Pour gagner en performances, il faut calculer la distance depuis le départ pour
# CHAQUE
# case piste en un seul BFS (beaucoup mieux niveau performances)


DIRECTIONS = Utils.neighbors4(0,0)
DIRECTIONS2 = DIRECTIONS.map { |y,x| [y*2, x*2]}

Utils.time {
  YEAR = 2024
  DAY = 20
  LEVEL = 1

  grid = Utils.read_matrix('day20-input.txt')
  height, width = Utils.get_size_of_grid(grid)
  start = Utils.find_in_grid("S", grid)
  finish = Utils.find_in_grid("E", grid)
  # emplacement: ###

  times = {}
  queue = [[start[0], start[1], 0]]
  visited = Set.new
  until queue.empty?
    y, x, steps = queue.shift
    next if visited.include?([y, x])
    visited.add([y, x])
    times[[y, x]] = steps
    DIRECTIONS.each do |dx, dy|
      nx, ny = x + dx, y + dy
      next unless Utils.in_bounds?(nx, ny, width, height)
      next if grid[ny][nx] == '#'
      next if visited.include?([ny, nx])
      queue.push([ny, nx, steps + 1])
    end
  end

  sum = 0
  times.each do |(y, x), steps|
    DIRECTIONS2.each do |dx, dy|
      nx, ny = x + dx, y + dy
      next unless Utils.in_bounds?(nx, ny, width, height)
      next unless times[[ny, nx]]

      gain = times[[ny, nx]] - steps - 2
      sum += 1 if gain >= 100
    end
  end
  
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.047771416 secondes

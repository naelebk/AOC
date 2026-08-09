#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

DIRECTIONS = Utils.neighbors4(0,0)
MIN = 2
MAX = 20

Utils.time {
  YEAR = 2024
  DAY = 20
  LEVEL = 2

  grid = Utils.read_matrix('day20-input.txt')
  height, width = Utils.get_size_of_grid(grid)
  start = Utils.find_in_grid("S", grid)
  finish = Utils.find_in_grid("E", grid)

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
    (-MAX..MAX).each do |dx|
      (-MAX..MAX).each do |dy|
        dist = dx.abs + dy.abs
        next unless dist.between?(MIN, MAX)
        nx, ny = x + dx, y + dy
        next unless Utils.in_bounds?(nx, ny, width, height)
        next unless times[[ny, nx]]
        gain = times[[ny, nx]] - steps - dist
        sum += 1 if gain >= 100
      end
    end
  end
  
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 4.940062636 secondes

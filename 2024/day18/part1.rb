#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

LENGTH = 71
LIMIT = 1024

Utils.time {
  YEAR = 2024
  DAY = 18
  LEVEL = 1

  input = Utils.read_csv('day18-sample-input.txt').map { |array| array.map(&:to_i) }
  start = [0,0]
  finish = [LENGTH - 1, LENGTH - 1]
  grid = Array.new(LENGTH) { ['.'] * LENGTH }

  input[0...LIMIT].each { |x,y| grid[y][x] = '#' }

  sum, path = Utils.bfs_grid_path(grid, start, finish, diagonal: false)
  Utils.debug(path)

  puts sum

  # cookie = Utils.get_cookie
  # Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.540379035 secondes

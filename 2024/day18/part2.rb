#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

LENGTH = 71

Utils.time {
  YEAR = 2024
  DAY = 18
  LEVEL = 1

  input = Utils.read_csv('day18-input.txt').map { |array| array.map(&:to_i) }
  start = [0,0]
  finish = [LENGTH - 1, LENGTH - 1]
  grid = Array.new(LENGTH) { ['.'] * LENGTH }

  sum = nil
  input.each do |x, y|
    grid[y][x] = '#'
    nb_path, path = Utils.bfs_grid_path(grid, start, finish, diagonal: false)
    if nb_path.nil?
      sum = "#{x},#{y}"
      break
    end
  end

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 19.638383502 secondes

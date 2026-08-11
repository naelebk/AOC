#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

def get_position_in_alphabet(char) = char.ord - 97 + 1

def elevation(char)
  case char
  when "S" then get_position_in_alphabet("a")
  when "E" then get_position_in_alphabet("z")
  else get_position_in_alphabet(char)
  end
end

Utils.time {
  YEAR = 2022
  DAY = 12
  LEVEL = 1

  grid = Utils.read_matrix('day12-input.txt')
  start = Utils.find_in_grid("S", grid)
  finish = Utils.find_in_grid("E", grid)
  sum, path = Utils.bfs_grid_path(
    grid,
    start,
    finish,
    passable: ->(from, to) { elevation(to) - elevation(from) <= 1 }
  )

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.020447122 secondes
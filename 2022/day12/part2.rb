#!/usr/bin/env ruby
# part2.rb
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
  LEVEL = 2

  grid = Utils.read_matrix('day12-input.txt')
  start = Utils.find_all_in_grid("a", grid)
  finish = Utils.find_in_grid("E", grid)
  min = Float::INFINITY
  start.each do |s|
    sum, path = Utils.bfs_grid_path(
      grid,
      s,
      finish,
      passable: ->(from, to) { elevation(to) - elevation(from) <= 1 }
    )
    min = [min, sum].min
  end

  puts min

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, min, cookie)
}
# Execution: 0.712420312 secondes
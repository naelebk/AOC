#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

DIRECTIONS = ["U", "D", "L", "R"].zip(Utils.neighbors4(0,0)).to_h

def count_visited_states(input)
  visited = Set.new
  hy, hx = [0, 0]
  ty, tx = [0, 0]
  visited.add([ty, tx])
  input.each do |motion|
    direction, number = motion
    dy, dx = DIRECTIONS[direction]
    number.times do
      hy += dy
      hx += dx
      delta_y = hy - ty
      delta_x = hx - tx
      if delta_y.abs > 1 || delta_x.abs > 1
        ty += delta_y <=> 0
        tx += delta_x <=> 0
        visited.add([ty, tx])
      end
    end
  end
  visited.size
end

Utils.time {
  YEAR = 2022
  DAY = 9
  LEVEL = 1

  input = Utils.read_csv("day09-input.txt", ' ').map { |a,b| [a, b.to_i] }
  sum = count_visited_states(input)
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.005658929 secondes

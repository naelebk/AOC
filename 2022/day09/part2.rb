#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

DIRECTIONS = ['U', "D", "L", "R"].zip(Utils.neighbors4(0,0)).to_h

def count_visited_states(input)
  visited = Set.new
  nodes = Array.new(10) { [0, 0] }
  visited.add(nodes[9])
  input.each do |motion|
    direction, number = motion
    dy, dx = DIRECTIONS[direction]
    number.times do
      nodes[0][0] += dy
      nodes[0][1] += dx
      (1...nodes.length).each do |i|
        leader_y, leader_x = nodes[i - 1]
        follower_y, follower_x = nodes[i]
        delta_y = leader_y - follower_y
        delta_x = leader_x - follower_x
        if delta_y.abs > 1 || delta_x.abs > 1
          nodes[i][0] += delta_y <=> 0
          nodes[i][1] += delta_x <=> 0
        end
      end
      visited.add(nodes[9])
    end
  end
  visited.size
end

Utils.time {
  YEAR = 2022
  DAY = 9
  LEVEL = 2

  input = Utils.read_csv("day09-input.txt", ' ').map { |a,b| [a, b.to_i] }
  sum = count_visited_states(input) + 1 #(+1 car on doit inclure "s")
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.017253363 secondes

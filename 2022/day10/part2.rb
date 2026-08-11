#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

CYCLE = 40

def do_operation(input)
  x = 1 # on demarre X a 1
  cycle = 0
  screen = []
  input.each do |(operation, value)|
    duration = operation == "addx" ? 2 : 1
    duration.times do
      position = cycle % CYCLE
      pixel = (position - x).abs <= 1 ? "#" : "."
      screen.push(pixel)
      cycle += 1
    end
    x += value if operation == "addx"
  end
  screen.each_slice(CYCLE) { |row| puts row.join }
end

Utils.time {
  YEAR = 2022
  DAY = 10
  LEVEL = 2

  input = Utils.read_csv("day10-input.txt", ' ').map { |a,b| [a, b.to_i] }
  do_operation(input)
  # In my output I can see "BGKAEREZ"
  sum = "BGKAEREZ"

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.000155504 secondes

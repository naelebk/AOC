#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

CYCLE = 40

def do_operation(input)
  x = 1 # on demarre X a 1
  cycle = 0
  values = []
  input.each do |(operation, value)|
    duration = operation == "addx" ? 2 : 1
    duration.times do
      cycle += 1
      values.push(x * cycle) if (cycle - 20) % CYCLE == 0
    end
    x += value if operation == "addx"
  end
  values.reduce(:+)
end
      
Utils.time {
  YEAR = 2022
  DAY = 10
  LEVEL = 1

  input = Utils.read_csv("day10-input.txt", ' ').map { |a,b| [a, b.to_i] }
  sum = do_operation(input)

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.000287281 secondes

#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

Utils.time {
  YEAR = 2024
  DAY = 01
  LEVEL = 2

  left, right = Utils.read_two_columns('day01-input.txt')
  t_right = right.tally
  sum = left.sum { |i| t_right[i].to_i * i }

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.001512576 secondes

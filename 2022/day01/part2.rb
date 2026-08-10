#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

Utils.time {
  YEAR = 2022
  DAY = 01
  LEVEL = 2

  input = Utils.read_blocks("day01-input.txt").map { |array| array.map(&:to_i) }
  sum = input.map { |array| array.reduce(:+) }.max(3).reduce(:+)
  
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.501713653 secondes

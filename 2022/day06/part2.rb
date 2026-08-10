#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

MARKER=14

Utils.time {
  YEAR = 2022
  DAY = 6
  LEVEL = 2

  input = Utils.read_lines('day06-input.txt').first.split('')
  size = input.size
  sum = 0
  0.upto(size-MARKER).each do |i|
    slice = input[i...i+MARKER]
    if slice.size == slice.uniq.size
      sum = i + MARKER
      break
    end
  end

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.639093008 secondes

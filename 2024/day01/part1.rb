#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

Utils.time {
  YEAR = 2024
  DAY = 01
  LEVEL = 1

  left, right = Utils.read_two_columns('day01-input.txt').map(&:sort)
  sum = left.zip(right).sum { |l, r| (l - r).abs }

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.001369527 secondes

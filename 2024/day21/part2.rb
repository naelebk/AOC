#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

Utils.time {
  YEAR = 2024
  DAY = 21
  LEVEL = 2

  input = Utils.read_matrix("day21-sample-input.txt").map(&:join)
  sum = 0

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}

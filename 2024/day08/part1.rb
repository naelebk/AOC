#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

Utils.time {
  YEAR = 2024
  DAY = 08
  LEVEL = 1

  input = Utils.read_lines('day08-input.txt')
  sum = 0

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}

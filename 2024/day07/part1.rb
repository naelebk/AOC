#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

Utils.time {
  YEAR = 2024
  DAY = 07
  LEVEL = 1

  input = Utils.read_lines('day07-input.txt')
  sum = 0

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}

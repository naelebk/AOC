#!/usr/bin/env ruby 
# part2.rb
require_relative '../../utils.rb'

Utils.time {
  YEAR = 2023
  DAY = 24
  LEVEL = 2

  input = Utils.read_lines('day24-input.txt')

  sum = 0
  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}

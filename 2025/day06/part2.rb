#!/usr/bin/env ruby 
# part2.rb
require_relative '../../utils.rb'

Utils.time {
  YEAR = 2025
  DAY = 6
  LEVEL = 2

  input = Utils.read_lines('day6-input.txt')

  sum = 0
  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}

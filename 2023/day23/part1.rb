#!/usr/bin/env ruby 
# part1.rb
require_relative '../../utils.rb'

Utils.time {
  YEAR = 2023
  DAY = 23
  LEVEL = 1

  input = Utils.read_lines('day23-input.txt')

  sum = 0
  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}

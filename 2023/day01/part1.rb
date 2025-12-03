#!/usr/bin/env ruby 
# part1.rb
require_relative '../../utils.rb'

Utils.time {
  YEAR = 2023
  DAY = 1
  LEVEL = 1

  input = Utils.read_lines('day1-input.txt')
  sum = 0

  input.each do |line|
    line = Utils.parse_ints(line).join.to_s.split('').map(&:to_i)
    length = line.length
    number = length == 1 ? line[0] * 10 + line[0] : line[0] * 10 + line[length - 1]
    sum += number
  end

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}

# Execution: 0.949616466 secondes

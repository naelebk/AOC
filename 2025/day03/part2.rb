#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

YEAR = 2025
DAY = 3
LEVEL = 2

input = Utils.read_lines('day3-input.txt')

sum = 0

input.each do |line|
  digits = line.strip.chars
  n = digits.length
  k = 12
  result = []
  start_pos = 0  
  k.times do |pos|
    remaining = k - pos
    max_search_pos = n - remaining
    max_digit = digits[start_pos..max_search_pos].max
    idx = digits[start_pos..max_search_pos].index(max_digit)
    result << max_digit
    start_pos += idx + 1
  end
  joltage = result.join.to_i
  sum += joltage
end

cookie = Utils.get_cookie
Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
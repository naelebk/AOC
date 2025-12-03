#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

YEAR = 2025
DAY = 3
LEVEL = 1

input = Utils.read_lines('day3-input.txt')

sum = 0

input.each do |line|
  digits = line.strip.chars.map(&:to_i)
  max_shock = 0
  (0...digits.length).each do |i|
    ((i+1)...digits.length).each do |j|
      shock = digits[i] * 10 + digits[j]
      max_shock = [max_shock, shock].max
    end
  end  
  sum += max_shock
end

cookie = Utils.get_cookie
Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)

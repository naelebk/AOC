#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

Utils.time {
  YEAR = 2025
  DAY = 3
  LEVEL = 1

  input = Utils.read_lines('day3-input.txt')

  sum = 0

  input.each do |line|
    digits = Utils.digits(line)
    max_shock = 0
    Utils.loop_n_levels(digits.length) do |i, j|
      shock = digits[i] * 10 + digits[j]
      max_shock = [max_shock, shock].max
    end
    sum += max_shock
  end

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}

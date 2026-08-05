#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

Utils.time {
  YEAR = 2024
  DAY = 03
  LEVEL = 2

  enabled = true
  sum = 0
  regex = /mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\)/

  input = Utils.read_lines('day03-input.txt').join
  input.scan(regex) do |x, y|
    match = Regexp.last_match[0]
    if match == "do()"
      enabled = true
    elsif match == "don't()"
      enabled = false
    elsif enabled
      sum += x.to_i * y.to_i
    end
  end

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}

# Execution: 0.80861213 secondes
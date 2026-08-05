#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

Utils.time {
  YEAR = 2024
  DAY = 03
  LEVEL = 1

  sum = Utils.read_lines('day03-input.txt').sum do |line|
    line.scan(/mul\((\d+),(\d+)\)/).sum do |array|
      array.map!(&:to_i).reduce(:*)
    end
  end

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.747227006 secondes

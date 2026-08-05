#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

def safe?(array)
  diffs = array.each_cons(2).map { |a, b| b - a }
  all_increasing = diffs.all? { |d| d >= 1 && d <= 3 }
  all_decreasing = diffs.all? { |d| d >= -3 && d <= -1 }
  all_increasing || all_decreasing
end
    

Utils.time {
  YEAR = 2024
  DAY = 02
  LEVEL = 1

  input = Utils.read_csv('day02-input.txt', ' ').map { |array| 
    array.map!(&:to_i) 
  }
  sum = input.sum { |array| safe?(array) ? 1 : 0 }

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}

# Execution: 0.003069603 secondes

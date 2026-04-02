#!/usr/bin/env ruby 
# part1.rb
require_relative '../../utils.rb'

def hash_algorithm(string)
  current = 0
  string.each_byte do |s|
    current += s
    current *= 17
    current %= 256
  end
  current
end

Utils.time {
  YEAR = 2023
  DAY = 15
  LEVEL = 1

  sum = Utils.read_lines('day15-input.txt')[0].split(',').sum do |s|
    hash_algorithm(s)
  end

  puts sum
  
  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.352124285 secondes

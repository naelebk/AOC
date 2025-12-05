#!/usr/bin/env ruby 
# part1.rb
require_relative '../../utils.rb'

Utils.time {
  YEAR = 2025
  DAY = 5
  LEVEL = 1

  blocks = Utils.read_blocks('day5-input.txt')
  ranges_lines = blocks[0]
  ids_lines = blocks[1]
  
  ranges = ranges_lines.map do |line|
    start, finish = line.split('-').map(&:to_i)
    [start, finish]
  end
  sum = ids_lines.count do |line|
    id = line.to_i
    ranges.any? { |start, finish| id >= start && id <= finish }
  end
  
  puts sum
  
  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}

# Execution: 0.459521814 secondes

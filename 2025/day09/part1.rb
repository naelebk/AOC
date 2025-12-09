#!/usr/bin/env ruby 
# part1.rb
require_relative '../../utils.rb'

def aire(a, b)
  x1, y1 = a
  x2, y2 = b
  (x2 - x1).abs + 1 * ((y2 - y1).abs + 1)
end

Utils.time {
  YEAR = 2025
  DAY = 9
  LEVEL = 1

  input = Utils.read_csv('day9-input.txt').map{ |e| e.map!(&:to_i) }
  max = 0
  input.each_with_index do |first, i|
    input.each_with_index do |second, j|
      next if i == j
      max = [aire(first, second), max].max
    end
  end

  puts max

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, max, cookie)
}

# Execution: 0.721780083 secondes

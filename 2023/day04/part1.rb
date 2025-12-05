#!/usr/bin/env ruby 
# part1.rb
require_relative '../../utils.rb'

Utils.time {
  YEAR = 2023
  DAY = 4
  LEVEL = 1

  input = Utils.read_lines('day4-input.txt')
  sum = 0
  input.each do |line|
    card_index, numbers = line.split(':')
    left, right = numbers.split('|').map(&:strip)
    left = left.split(' ').map(&:to_i)
    right = right.split(' ').map(&:to_i)
    sum += 1 << ((left.reject { |i|
      !right.include?(i)
    }.size) - 1)
  end

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}

# Execution: 0.396849528 secondes

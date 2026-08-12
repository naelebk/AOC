#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

FIRST = [[2]]
SECOND = [[6]]

def contains_something?(tab)
  return true unless tab.is_a?(Array)
  return false if tab.empty?
  tab.any? { |t| contains_something?(t) }
end

def compare(left, right)
  return left <=> right if left.is_a?(Integer) && right.is_a?(Integer)
  left = [left] if left.is_a?(Integer)
  right = [right] if right.is_a?(Integer)
  left.zip(right).each do |l, r|
    return 1 if r.nil?
    result = compare(l, r)
    return result unless result.zero?
  end
  left.size <=> right.size
end

def sort_input(input) = input.sort { |a,b|
  contains_something?(a) || contains_something?(b) ? compare(a,b) : a <=> b 
}

Utils.time {
  YEAR = 2022
  DAY = 13
  LEVEL = 2

  input = Utils.read_blocks("day13-input.txt").map { |array|
    array.map { |a| eval(a) }
  }
  tab = []
  input.each { |(l,r)| tab.push(l).push(r) }
  tab.push(FIRST).push(SECOND)
  tab = sort_input(tab)

  sum = [tab.find_index { |t| t == FIRST } + 1, tab.find_index { |t| t == SECOND } + 1].reduce(:*)
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.007715741 secondes

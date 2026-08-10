#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

def range_include?(range_a, range_b) = range_a.cover?(range_b) || range_b.cover?(range_a) ? 1 : 0

Utils.time {
  YEAR = 2022
  DAY = 4
  LEVEL = 1

  sum = Utils.read_csv('day04-input.txt').map { |array|
    l, r = array
    l.split('-').map(&:to_i) + r.split('-').map(&:to_i)
  }.sum { |a1,a2,b1,b2| range_include?((a1..a2), (b1..b2)) }

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.797376702 secondes

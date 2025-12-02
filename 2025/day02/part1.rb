#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

YEAR = 2025
DAY = 2
LEVEL = 1

def is_invalid_id(id)
  the_id = id.to_s
  mid = the_id.length / 2
  first_part = the_id.slice(0...mid)
  second_part = the_id.slice(mid..-1)
  first_part == second_part  
end

input = Utils.read_lines('day2-input.txt')[0] # chaine uniquement, on remet en tableau après
items = input.split(',')

sum = 0
items.each do |range|
  first, last = range.split('-')
  first = first.to_i
  last = last.to_i
  first.upto(last) do |i| sum += i if is_invalid_id(i) end
end
puts sum

cookie = Utils.get_cookie
Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)

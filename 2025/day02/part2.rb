#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

def is_valid_id(id)
  the_id = id.to_s
  length = the_id.length
  
  (1..length/2).each do |seq_length|
    next unless length % seq_length == 0
    sequence = the_id[0...seq_length]
    if the_id == sequence * (length / seq_length)
      return false
    end
  end
  
  true
end

input = Utils.read_lines('day2-input.txt')[0] # chaine uniquement, on remet en tableau après
items = input.split(',')

sum = 0
items.each do |range|
  first, last = range.split('-')
  first = first.to_i
  last = last.to_i
  first.upto(last) do |i| sum += i unless is_valid_id(i) end
end
puts sum

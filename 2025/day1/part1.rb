#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

input = Utils.read_lines('day1-input.txt')
code = 50
count = 0 

input.each do |x|
    sens = x[0]
    number = x[1..-1].to_i
    if sens == "L"
        code = (code - number) % 100
    else
        code = (code + number) % 100
    end
    count += 1 if code == 0
end

puts count


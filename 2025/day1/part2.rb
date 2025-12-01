#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

input = Utils.read_lines('day1-input.txt')
code = 50
count = 0 

input.each do |x|
  sens = x[0]
  number = x[1..-1].to_i
  start = code

  if sens == "L"
    if start == 0
      count += number / 100
    else
      if number >= start
        count += 1 + (number - start) / 100
      end
    end
    nouveau = (code - number) % 100
    code = nouveau
  else
    if start == 0
      count += number / 100
    else
      d = (100 - start) % 100
      if d != 0 && number >= d
        count += 1 + (number - d) / 100
      end
    end
    nouveau = (code + number) % 100
    code = nouveau
  end
end

puts count

#!/usr/bin/env ruby 
# part1.rb
require_relative '../../utils.rb'

def find_reflection(matrix)
  (0...matrix.length - 1).each do |i|
    if matrix[i] == matrix[i + 1]
      size = [i + 1, matrix.length - (i + 1)].min
      if (0...size).all? { |offset| matrix[i - offset] == matrix[i + 1 + offset] }
        return i + 1
      end
    end
  end
  0
end

Utils.time {
  YEAR = 2023
  DAY = 13
  LEVEL = 1

  sum = Utils.read_blocks('day13-input.txt').sum do |block|
    horizontal = find_reflection(block)
    vertical = find_reflection(block.map(&:chars).transpose.map(&:join))
    horizontal * 100 + vertical
  end
  
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.435189035 secondes

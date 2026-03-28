#!/usr/bin/env ruby 
# part2.rb
require_relative '../../utils.rb'

def count_diffs(s1, s2)
  (0...s1.length).count { |i| s1[i] != s2[i] }
end

def find_reflection(matrix)
  (0...matrix.length - 1).each do |i|
    total_diffs = 0
    size = [i + 1, matrix.length - (i + 1)].min
    (0...size).each do |offset|
      total_diffs += count_diffs(matrix[i - offset], matrix[i + 1 + offset])
      break if total_diffs > 1
    end
    return i + 1 if total_diffs == 1
  end
  0
end

Utils.time {
  YEAR = 2023
  DAY = 13
  LEVEL = 2

  sum = Utils.read_blocks('day13-input.txt').sum do |block|
    horizontal = find_reflection(block)
    vertical = find_reflection(block.map(&:chars).transpose.map(&:join))
    horizontal * 100 + vertical
  end
  
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.420183136 secondes

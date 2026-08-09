#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

def count_arrangements(design, towel_patterns, position, memo)
  return 1 if position == design.length
  return memo[position] if memo.key?(position)
  count = 0
  towel_patterns.each do |towel|
    end_pos = position + towel.length
    count += count_arrangements(design, towel_patterns, end_pos, memo) if end_pos <= design.length && design[position...end_pos] == towel
  end  
  memo[position] = count
  count
end

def possible_design_count(design, towel_patterns) = count_arrangements(design, towel_patterns, 0, {})

Utils.time {
  YEAR = 2024
  DAY = 19
  LEVEL = 2

  towel_patterns, designs = Utils.read_blocks("day19-input.txt")
  towel_patterns = towel_patterns[0].split(',').map(&:strip)
  
  sum = designs.sum { |design| possible_design_count(design, towel_patterns) }
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 2.503368496 secondes

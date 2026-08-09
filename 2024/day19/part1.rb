#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

def can_build(design, towel_patterns, position, impossible_positions)
  return true if position == design.length
  return false if impossible_positions.include?(position)
  
  found = towel_patterns.any? do |towel|
    end_pos = position + towel.length
    end_pos <= design.length && design[position...end_pos] == towel && can_build(design, towel_patterns, end_pos, impossible_positions)
  end
  impossible_positions.add(position) unless found
  found
end

def possible_design(design, towel_patterns) = can_build(design, towel_patterns, 0, Set.new) ? 1 : 0

Utils.time {
  YEAR = 2024
  DAY = 19
  LEVEL = 1

  towel_patterns, designs = Utils.read_blocks("day19-input.txt")
  towel_patterns = towel_patterns[0].split(',').map(&:strip)
  
  sum = designs.sum { |design| possible_design(design, towel_patterns) }
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 1.092362077 secondes

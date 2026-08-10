#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

def get_common_char(string) = string[0...string.size/2].split('').intersection(string[string.size/2...string.size].split('')).first

# 'A' devient 27, 'a' devient 1
def get_position_in_alphabet(char) = ('A'..'Z').include?(char) ? char.ord - 65 + 27  : char.ord - 97 + 1

Utils.time {
  YEAR = 2022
  DAY = 3
  LEVEL = 1

  input = Utils.read_lines('day03-input.txt')
  sum = input.sum { |line| 
    common_char = get_common_char(line)
    get_position_in_alphabet(common_char)
  }

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.552694375 secondes

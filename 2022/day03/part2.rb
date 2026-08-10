#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

def get_common_char(a,b,c)
  first = a.split('')
  second = b.split('')
  third = c.split('')
  first.intersection(second.intersection(third)).first
end

# 'A' devient 27, 'a' devient 1
def get_position_in_alphabet(char) = ('A'..'Z').include?(char) ? char.ord - 65 + 27  : char.ord - 97 + 1

Utils.time {
  YEAR = 2022
  DAY = 3
  LEVEL = 2

  input = Utils.read_lines('day03-input.txt')
  sum = 0
  length = input.size
  i = 0
  while i <= length - 3
    a = input[i]
    b = input[i+1]
    c = input[i+2]
    common_char = get_common_char(a,b,c)
    sum += get_position_in_alphabet(common_char)
    i += 3
  end

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.773222046 secondes

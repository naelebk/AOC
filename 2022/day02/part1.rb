#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

ROCK = 1
PAPER = 2
SCISSOR = 3
LOOSE = 0
DRAW = 3
WIN = 6

SHAPE = { 'X' => ROCK, 'Y' => PAPER, 'Z' => SCISSOR }
BEATS = { 'A' => 'Z', 'B' => 'X', 'C' => 'Y' }
SAME = { 'A' => 'X', 'B' => 'Y', 'C' => 'Z' }

# rock = A and X, paper = B and Y, scissor = C and Z
def round(a, b)
  outcome = if b == SAME[a]
    DRAW
  elsif b == BEATS[a]
    LOOSE
  else
    WIN
  end
  SHAPE[b] + outcome
end

Utils.time {
  YEAR = 2022
  DAY = 2
  LEVEL = 1

  input = Utils.read_csv('day02-input.txt', ' ')
  sum = input.sum { |a, b| round(a,b) }

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.764650951 secondes

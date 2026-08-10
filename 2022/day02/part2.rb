#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

ROCK = 1
PAPER = 2
SCISSOR = 3
LOOSE = 0
DRAW = 3
WIN = 6

SHAPE = { 'X' => LOOSE, 'Y' => DRAW, 'Z' => WIN }

BEATS = {
  'A' => { 'X' => SCISSOR, 'Y' => ROCK, 'Z' => PAPER },
  'B' => { 'X' => ROCK, 'Y' => PAPER, 'Z' => SCISSOR },
  'C' => { 'X' => PAPER, 'Y' => SCISSOR, 'Z' => ROCK }
}

def round(a, b) = BEATS[a][b] + SHAPE[b]

Utils.time {
  YEAR = 2022
  DAY = 2
  LEVEL = 2

  input = Utils.read_csv('day02-input.txt', ' ')
  sum = input.sum { |a, b| round(a,b) }

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.836358149 secondes

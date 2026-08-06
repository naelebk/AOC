#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

WIDTH = 101
HEIGHT = 103

def mean(array) = array.sum.to_f / array.size
def variance(array, mean) = array.sum { |x| (x - mean)**2 } / array.size

Utils.time {
  YEAR = 2024
  DAY = 14
  LEVEL = 2

  input = Utils.read_lines('day14-input.txt').map { |line| Utils.parse_ints(line) }
  robots = input

  best_t = nil
  best_score = nil

  (1..10000).each do |t|
    positions = robots.map { |px, py, vx, vy|
      [(px + vx*t) % WIDTH, (py + vy*t) % HEIGHT]
    }
    xs = positions.map(&:first)
    ys = positions.map(&:last)
    score = variance(xs, mean(xs)) + variance(ys,  mean(ys))
    if best_score.nil? || score < best_score
      best_score = score
      best_t = t
    end
  end

  puts best_t

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, best_t, cookie)
}
# Execution: 1.885875368 secondes

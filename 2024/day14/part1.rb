#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

MOVES = 100
WIDTH = 101
HEIGHT = 103

def move_robot(robot)
  px, py, vx, vy = robot
  vx = ((px + MOVES * vx) % WIDTH + WIDTH) % WIDTH
  vy = ((py + MOVES * vy) % HEIGHT + HEIGHT) % HEIGHT
  [vx, vy]
end

Utils.time {
  YEAR = 2024
  DAY = 14
  LEVEL = 1

  input = Utils.read_lines('day14-input.txt').map { |line| Utils.parse_ints(line) }
  quarts = [0] * 4
  half_width = WIDTH / 2
  half_height = HEIGHT / 2
  
  input.each do |robot|
    vx, vy = move_robot(robot)
    if vx < half_width && vy < half_height
      quarts[0] += 1
    elsif vx > half_width && vy < half_height
      quarts[1] += 1
    elsif vx < half_width && vy > half_height
      quarts[2] += 1
    elsif vx > half_width && vy > half_height
      quarts[3] += 1
    end
  end

  sum = quarts.reduce(:*)
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.658344695 secondes

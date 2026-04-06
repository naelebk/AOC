#!/usr/bin/env ruby 
# part2.rb
require_relative '../../utils.rb'

DIRECTIONS = {
  0 => [0, 1],   # droite
  2 => [0, -1],  # gauche
  3 => [-1, 0],  # haut
  1 => [1, 0]    # bas
}

def color_to_number(color)
  hex = color.split('')
  last = hex.pop
  symbol = hex.shift
  hex.join('').to_i(16)
end

def get_direction_of_color(color)
  color.split('')[-1].to_i
end

def next_coords(direction, nb)
  di, dj = DIRECTIONS[direction]
  [di * nb, dj * nb]
end

def get_lagun_volume(input)
  current_i, current_j = 0, 0
  vertices = []
  boundary = 0
  input.each do |_, _, color|
    direction = get_direction_of_color(color)
    nb = color_to_number(color)
    boundary += nb
    di, dj = next_coords(direction, nb)
    current_i += di
    current_j += dj
    vertices << [current_i, current_j]
  end
  n = vertices.size
  area = (vertices.each_with_index.sum { |(i, j), idx|
    ni, nj = vertices[(idx + 1) % n]
    (j + nj) * (i - ni)
  } / 2).abs
  area - boundary / 2 + 1 + boundary
end

Utils.time {
  YEAR = 2023
  DAY = 18
  LEVEL = 2

  input = Utils.read_csv('day18-input.txt', ' ').map do |direction, nb, color|
    [direction, nb.to_i, color.gsub('(', '').gsub(')', '')]
  end

  sum = get_lagun_volume(input)

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.409400109 secondes

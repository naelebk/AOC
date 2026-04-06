#!/usr/bin/env ruby 
# part1.rb
require_relative '../../utils.rb'

DIRECTIONS = {
  "R" => [0, 1],   # droite
  "L" => [0, -1],  # gauche
  "U" => [-1, 0],  # haut
  "D" => [1, 0]    # bas
}

def next_coords(direction, nb)
  di, dj = DIRECTIONS[direction]
  [di * nb, dj * nb]
end

def get_lagun_volume(input)
  current_i, current_j = 0, 0
  vertices = []
  boundary = 0
  input.each do |direction, nb, color|
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

  # Formule du lacet pour calculer l'aire d'un polygone
  # https://fr.wikipedia.org/wiki/Th%C3%A9or%C3%A8me_de_Pick
  # Théorème de Pick : 
  # i = A - b/2 + 1, résultat = i + b
  area - boundary / 2 + 1 + boundary
end

Utils.time {
  YEAR = 2023
  DAY = 18
  LEVEL = 1

  input = Utils.read_csv('day18-input.txt', ' ').map do |direction, nb, color|
    [direction, nb.to_i, color]
  end
  sum = get_lagun_volume(input)

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.452942075 secondes

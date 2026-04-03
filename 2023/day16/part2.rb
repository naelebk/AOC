#!/usr/bin/env ruby 
# part2.rb
require_relative '../../utils.rb'

'''
direction est une bitmap :
0b00 -> droite
0b01 -> gauche
0b10 -> haut
0b11 -> bas
'''
def next_direction(i, j, direction, height, width)
  case direction
  when 0b00 # droite
    new_i, new_j = i + 1, j
  when 0b01 # gauche
    new_i, new_j = i - 1, j
  when 0b10 # haut
    new_i, new_j = i, j - 1
  when 0b11 # bas
    new_i, new_j = i, j + 1
  else
    return nil # Direction invalide
  end
  # On vérifie si on est toujours dans la grille
  return [new_i, new_j] if Utils.in_bounds?(new_i, new_j, width, height)
  nil
end

def solve_lava(matrix, start)
  height, width = Utils.get_size_of_grid(matrix)
  # On commence à gauche de la première case, direction droite (0b00)
  queue = start
  seen_states = Set.new
  energized = Set.new

  while queue.any?
    i, j, dir = queue.shift
    pos = next_direction(i, j, dir, height, width)
    next if pos.nil? # on est sorti de la grille
    new_i, new_j = pos

    state = [new_i, new_j, dir]
    next if seen_states.include?(state)
    seen_states.add(state)
    energized.add([new_i, new_j])

    char = matrix[new_j][new_i]
    case char
    when '.'
      queue << [new_i, new_j, dir]
    when '/'
      new_dir = case dir
                when 0b00 then 0b10 # droite -> haut
                when 0b01 then 0b11 # gauche -> bas
                when 0b10 then 0b00 # haut -> droite
                when 0b11 then 0b01 # bas -> gauche
                end
      queue << [new_i, new_j, new_dir]
    when '\\'
      new_dir = case dir
                when 0b00 then 0b11 # droite -> bas
                when 0b01 then 0b10 # gauche -> haut
                when 0b10 then 0b01 # haut -> gauche
                when 0b11 then 0b00 # bas -> droite
                end
      queue << [new_i, new_j, new_dir]
    when '|'
      if dir == 0b00 || dir == 0b01 # split
        queue << [new_i, new_j, 0b10] # vers le haut
        queue << [new_i, new_j, 0b11] # vers le bas
      else
        queue << [new_i, new_j, dir] # on traverse
      end
    when '-'
      if dir == 0b10 || dir == 0b11 # split
        queue << [new_i, new_j, 0b00] # vers la droite
        queue << [new_i, new_j, 0b01] # vers la gauche
      else
        queue << [new_i, new_j, dir] # on traverse
      end
    end
  end

  energized.size
end

Utils.time {
  YEAR = 2023
  DAY = 16
  LEVEL = 2

  matrix = Utils.read_matrix('day16-input.txt')
  height, width = Utils.get_size_of_grid(matrix)
  starts = []
  (0...height).each { |j| starts << [[-1, j, 0b00]] }
  (0...height).each { |j| starts << [[width, j, 0b01]] }
  (0...width).each { |i| starts << [[i, -1, 0b11]] }
  (0...width).each { |i| starts << [[i, height, 0b10]] }

  sum = starts.map { |start| solve_lava(matrix, start) }.max  
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 3.379220217 secondes

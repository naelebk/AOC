#!/usr/bin/env ruby 
# part2.rb
require_relative '../../utils.rb'

'''
direction est une bitmap :
0b00 -> droite ~ tout droit en gros
0b01 -> gauche
0b10 -> haut
0b11 -> bas
'''

DIRECTIONS = {
  0b00 => [0, 1],   # droite
  0b01 => [0, -1],  # gauche
  0b10 => [-1, 0],  # haut
  0b11 => [1, 0]    # bas
}

def allowed_turns(direction)
  case direction
  when 0b00 then [0b10, 0b11, 0b00]  # droite : peut aller haut, bas, ou continuer droite
  when 0b01 then [0b10, 0b11, 0b01]  # gauche : peut aller haut, bas, ou continuer gauche
  when 0b10 then [0b00, 0b01, 0b10]  # haut : peut aller droite, gauche, ou continuer haut
  when 0b11 then [0b00, 0b01, 0b11]  # bas : peut aller droite, gauche, ou continuer bas
  end
end

def solve_heat_loss(matrix)
  height, width = Utils.get_size_of_grid(matrix)
  # on démarre avec droite et bas, consecutive = 0 pour pas bloquer le début
  queue = [
    [0, 0, 0, 0b00, 0], # droite
    [0, 0, 0, 0b11, 0] # bas
  ]
  seen_states = {}
  while queue.any?
    cost, i, j, dir, consecutive = queue.shift
    return cost if i == height - 1 && j == width - 1
    allowed_turns(dir).each do |new_dir|
      di, dj = DIRECTIONS[new_dir]
      new_i, new_j = i + di, j + dj
      next unless Utils.in_bounds?(new_i, new_j, width, height)
      new_consecutive = (new_dir == dir) ? consecutive + 1 : 1
      next if new_consecutive > 10
      # au moins 4 avant de tourner et différent de 0 pour éviter de bloquer la première itération
      next if new_dir != dir && consecutive < 4 && consecutive != 0
      # ------------------------------------------------------------------------------------------
      new_cost = cost + matrix[new_i][new_j]
      state = [new_i, new_j, new_dir, new_consecutive]
      next if seen_states[state] && seen_states[state] <= new_cost
      seen_states[state] = new_cost
      # insertion triée plutôt que sort_by! à chaque tour
      idx = queue.bsearch_index { |s| s[0] >= new_cost } || queue.size
      queue.insert(idx, [new_cost, new_i, new_j, new_dir, new_consecutive])
    end
  end
  nil
end

Utils.time {
  YEAR = 2023
  DAY = 17
  LEVEL = 2

  input = Utils.read_numbers('day17-input.txt', '')
  sum = solve_heat_loss(input)
  
  puts sum
  
  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 3.628317718 secondes

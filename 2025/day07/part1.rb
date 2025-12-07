#!/usr/bin/env ruby 
# part1.rb
require_relative '../../utils.rb'

Utils.time {
  YEAR = 2025
  DAY = 7
  LEVEL = 1

  grid = Utils.read_matrix("day7-input.txt")
  height, width = Utils.get_size_of_grid(grid)
  start_x, start_y = Utils.find_in_grid("S", grid)
  beams = [[start_x, start_y]]
  splits = 0
  visited = Set.new # on garde les visités dans un coin pour éviter les doublons
  # set est une bonne structure de données pour justement éviter les doublons

  # pour cela, on itère jusqu'à ce que les poutres soient vides (le tableau du moins ahahaha)
  until beams.empty?
    x, y = beams.shift
    while y < height
      cell = grid[y][x]
      if cell == '^'
        split_key = [x, y]
        unless visited.include?(split_key)
          visited << split_key
          splits += 1 # si on a pas encore visité cette partie alors on split
          if x > 0
            beams << [x - 1, y + 1]
          end
          if x < width - 1
            beams << [x + 1, y + 1]
          end
        end        
        break
      end
      y += 1
    end
  end

  puts splits

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, splits, cookie)
}

# Execution: 0.442218365 secondes

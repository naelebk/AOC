#!/usr/bin/env ruby 
# part2.rb
require_relative '../../utils.rb'

# la file explose je dois faire autrement...
# je laisse ma première fonction pour que vous puissiez voir qu'une approche
# un peu plus naïve qui ne prend pas en compte la complexité de l'algo ne peut
# pas fonctionner sur une grille - tq dans l'input - qui est trop grande
# mais cette fonction marche tout de même sur une taille petite de grille
# (par exemple, elle marche parfaitement dans l'input simple)
'''
def count_timelines(grid, start_x, start_y)
  height = grid.size
  width = grid[0].size
  timelines = Set.new # nos lignes temporelles quon doit compter
  # encore une fois, la structure Set nous permet déviter les doublons au maximum
  # (bien quici cest la file (queue) qui nous permet de les éviter justement)
  queue = [[start_x, start_y + 1, Set.new([[start_x, start_y]])]]
  until queue.empty?
    x, y, path = queue.shift
    if y >= height || x < 0 || x >= width
      timelines << path
      next
    end
    cell = grid[y][x]
    current_path = path.dup
    current_path << [x, y]    
    if cell == "^"
      if x > 0 # on est à gauche dans la grille
        queue << [x - 1, y + 1, current_path.dup]
      else
        timelines << current_path
      end
      if x < width - 1 # on est à droite dans la grille
        queue << [x + 1, y + 1, current_path.dup]
      else
        timelines << current_path
      end
    else # si ni à gauche ni à droite ==> tout droit
      queue << [x, y + 1, current_path]
    end
  end  
  timelines.size
end
'''

def count_timelines(grid, start_x, start_y)
  height = grid.size
  width = grid[0].size
  memo = {}
  def explore(grid, x, y, height, width, visited, memo)
    return 1 if y >= height || x < 0 || x >= width
    state = [x, y]
    return 0 if visited.include?(state)
    return memo[state] if memo.key?(state) # si déjà fait depuis cette position (pas de doublon)
    visited_copy = visited.dup
    visited_copy << state
    cell = grid[y][x]
    result = 0
    if cell == '^' # gauche ET droite
      result += explore(grid, x - 1, y + 1, height, width, visited_copy, memo) # gauche précismt
      result += explore(grid, x + 1, y + 1, height, width, visited_copy, memo) # droite précismt
      # on aurait pu faire un left += ... right += ... ; puis faire result += left + right
      # vsy flemme ahahaha
      # aussi, la récursivité n'est pas giga conseillée généralement
      # mais dans notre cas ça fonctionne pas trop mal
    else
      result = explore(grid, x, y + 1, height, width, visited_copy, memo) # on est tout droit
    end
    memo[state] = result
    result
  end
  explore(grid, start_x, start_y + 1, height, width, Set.new, memo)
end

Utils.time {
  YEAR = 2025
  DAY = 7
  LEVEL = 2

  grid = Utils.read_matrix("day7-input.txt")
  start_x, start_y = Utils.find_in_grid("S", grid)
  sum = count_timelines(grid, start_x, start_y)

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}

# Execution: 0.436051707 secondes

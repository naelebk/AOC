#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

=begin
J'ai énormément galéré, voici le code que j'avais initialement qui faisait explosé la file.
En fait, plus optimisé, je vérifie directement si un rectangle croise le périmètre et on passe d'une
complexité en O(n^2) à O(k * n) !
=end

def test_box(input, box_min_x, box_min_y, box_max_x, box_max_y)
  n = input.size
  n.times do |i|
    sx, sy = input[i]
    ex, ey = input[(i + 1) % n]
    dx = ex <=> sx
    dy = ey <=> sy
    if dx != 0
      next if sy <= box_min_y || sy >= box_max_y # en dehors
      next if sx >= box_max_x && ex >= box_max_x # à droite
      next if sx <= box_min_x && ex <= box_min_x # à gauche
      return false if sx > box_min_x && sx < box_max_x
      return false if ex > box_min_x && ex < box_max_x
      return false if sx <= box_min_x && ex >= box_max_x
      return false if ex <= box_min_x && sx >= box_max_x
    else # sgmt vertical
      next if sx <= box_min_x || sx >= box_max_x # en dehors
      next if sy >= box_max_y && ey >= box_max_y # à droite
      next if sy <= box_min_y && ey <= box_min_y # à gauche
      return false if sy > box_min_y && sy < box_max_y
      return false if ey > box_min_y && ey < box_max_y
      return false if sy <= box_min_y && ey >= box_max_y
      return false if ey <= box_min_y && sy >= box_max_y
    end
  end  
  true
end

Utils.time {
  YEAR = 2025
  DAY = 9
  LEVEL = 2
  
  input = Utils.read_csv('day9-input.txt').map { |e| e.map!(&:to_i) }
  boxes = []
  n = input.size  
  n.times do |i|
    ((i+1)...n).each do |j|
      x1, y1 = input[i]
      x2, y2 = input[j]
      min_x = [x1, x2].min
      max_x = [x1, x2].max
      min_y = [y1, y2].min
      max_y = [y1, y2].max
      area = (max_x - min_x + 1) * (max_y - min_y + 1)
      boxes << [area, min_x, min_y, max_x, max_y]
    end
  end
  boxes.sort_by! { |area, *_| -area }
  boxes.each_with_index do |(area, min_x, min_y, max_x, max_y), idx|  
    if test_box(input, min_x, min_y, max_x, max_y)
      puts area      
      cookie = Utils.get_cookie
      Utils.submit_answer(YEAR, DAY, LEVEL, area, cookie)
      break
    end
  end
}

# Execution: 1.582652823 secondes
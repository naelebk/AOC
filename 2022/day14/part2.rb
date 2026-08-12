#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

def build_blocked(input)
  blocked = Set.new # set en O(1) pour reconstruire les coordonnées de la grille à l'infini
  input.each do |path|
    path.each_cons(2) do |(x1, y1), (x2, y2)|
      if y1 == y2
        lo, hi = [x1, x2].minmax
        (lo..hi).each { |x| blocked.add([x, y1]) }
      else
        lo, hi = [y1, y2].minmax
        (lo..hi).each { |y| blocked.add([x1, y]) }
      end
    end
  end
  blocked
end

def drop_one(blocked, floor_y, source = [500, 0])
  x, y = source
  loop do
    return [x, y] if y + 1 == floor_y
    if !blocked.include?([x, y + 1])
      y += 1
    elsif !blocked.include?([x - 1, y + 1])
      y += 1
      x -= 1
    elsif !blocked.include?([x + 1, y + 1])
      y += 1
      x += 1
    else
      return [x, y]
    end
  end
end

def pour_sand(blocked, floor_y, source = [500, 0])
  count = 0
  until blocked.include?(source)
    blocked.add(drop_one(blocked, floor_y, source))
    count += 1
  end
  count
end


Utils.time {
  YEAR = 2022
  DAY = 14
  LEVEL = 2

  input = Utils.read_csv("day14-input.txt", "->").map do |array|
    array.map { |value| value.strip.split(",").map(&:to_i) }
  end
  blocked = build_blocked(input)
  floor_y = blocked.map(&:last).max + 2 # on nous demande de rajouter 2 étages (de 9 à 11)
  
  sum = pour_sand(blocked, floor_y)
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 2.265692937 secondes

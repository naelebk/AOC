#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

def settled_bricks(input)
  bricks = input.sort_by { |_x1, _y1, z1, _x2, _y2, _z2| z1 }
  height_map = Hash.new(0)
  brick_map = Hash.new(nil)
  supports = Utils.empty_graph
  supported_by = Utils.empty_graph
  bricks.each_with_index do |brick, id|
    x1, y1, z1, x2, y2, z2 = brick
    height = z2 - z1    
    # liste de toutes les coordonnées (x, y) de cette brique
    xy_cubes = []
    (x1..x2).each do |x|
      (y1..y2).each do |y|
        xy_cubes << [x, y]
      end
    end

    max_below_z = xy_cubes.map { |point| height_map[point] }.max
    new_z1 = max_below_z + 1
    new_z2 = new_z1 + height

    xy_cubes.each do |point|
      if height_map[point] == max_below_z && !brick_map[point].nil?
        supporting_brick_id = brick_map[point]
        supported_by[id].add(supporting_brick_id)
        supports[supporting_brick_id].add(id)
      end
    end
    xy_cubes.each do |point|
      height_map[point] = new_z2
      brick_map[point] = id
    end
  end
  # total de briques et les graphes de dépendance
  [bricks.size, supports, supported_by]
end

def count_chain_reaction(input)
  total_bricks, supports, supported_by = settled_bricks(input)
  total_falling = 0
  (0...total_bricks).each do |start_id|
    fallen = Set.new([start_id])
    queue = [start_id] # file BFS classique (mais logique différente des fonctions Utils)
    until queue.empty?
      current = queue.shift
      supports[current].each do |above|
        next if fallen.include?(above)
        # tous les supporters doivent être dans 'fallen'
        if supported_by[above].subset?(fallen)
          fallen.add(above)
          queue << above
        end
      end
    end
    total_falling += (fallen.size - 1)
  end
  total_falling
end

Utils.time {
  YEAR = 2023
  DAY = 22
  LEVEL = 2

  input = Utils.read_csv('day22-input.txt', '~').map { |left, right|
    (left.split(',') + right.split(',')).map(&:to_i)
  }
  sum = count_chain_reaction(input)
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.838678988 secondes

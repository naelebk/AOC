#!/usr/bin/env ruby
# part1.rb
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

def count_safely_disintegrated(input)
  total_bricks, supports, supported_by = settled_bricks(input)
  count = 0
  (0...total_bricks).each do |id|
    # Une brique est sûre si TOUTES les briques situées au-dessus ont au moins 2 supporters (donc un autre soutien que 'id')
    is_safe = supports[id].all? { |supported_id| supported_by[supported_id].size > 1 }
    count += 1 if is_safe
  end
  count
end

Utils.time {
  YEAR = 2023
  DAY = 22
  LEVEL = 1

  input = Utils.read_csv('day22-input.txt', '~').map { |left, right|
    (left.split(',') + right.split(',')).map(&:to_i)
  }
  sum = count_safely_disintegrated(input)
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.629509299 secondes

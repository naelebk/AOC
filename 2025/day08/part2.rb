#!/usr/bin/env ruby 
# part2.rb
require_relative '../../utils.rb'

Utils.time {
  YEAR = 2025
  DAY = 8
  LEVEL = 2

  boxes = Utils.read_csv('day8-input.txt').map { |element| element.map!(&:to_i) }
  n = boxes.size
  dists = []
  Utils.loop_n_levels(n) do |i, j|
    dist = (boxes[i][0]-boxes[j][0])**2 + (boxes[i][1]-boxes[j][1])**2 + (boxes[i][2]-boxes[j][2])**2
    dists << [dist, i, j]
  end
  dists.sort!
  parent = (0...n).to_a
  size = [1] * n
  
  find = ->(x) {
    if parent[x] != x
      parent[x] = find[parent[x]]
    end
    parent[x]
  }
  
  last_i = nil
  last_j = nil
  
  dists.each { |dist_val, i, j|
    root_i, root_j = find[i], find[j]
    next if root_i == root_j # déjà connectés
    if size[root_i] < size[root_j]
      parent[root_i] = root_j
      size[root_j] += size[root_i]
    else
      parent[root_j] = root_i
      size[root_i] += size[root_j]
    end
    last_i = i
    last_j = j
    break if size[find[0]] == n # si tout est déjà connecté en 1 seul circuit
  }
  
  result = boxes[last_i][0] * boxes[last_j][0]
  puts result

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, result, cookie)
}

# Execution: 1.424303243 secondes
# Pas ma version la plus opti encore une fois, mais fonctionne malgré tout

#!/usr/bin/env ruby 
# part1.rb
require_relative '../../utils.rb'

Utils.time {
  YEAR = 2025
  DAY = 8
  LEVEL = 1

  boxes = Utils.read_csv('day8-input.txt').map { |element| element.map!(&:to_i) }
  n = boxes.size
  dists = []
  (0...n).each { |i|
    (i+1...n).each { |j|
      dist = (boxes[i][0]-boxes[j][0])**2 + (boxes[i][1]-boxes[j][1])**2 + (boxes[i][2]-boxes[j][2])**2
      dists << [dist, i, j]
    }
  }
  dists.sort!
  parent = (0...n).to_a
  size = [1] * n

  find = ->(x) { # lambda fonction pour trouver l'union
    if parent[x] != x
      parent[x] = find[parent[x]]
    end
    parent[x]
  }

  attempts = 0
  dists.each { |dist_val, i, j|
    break if attempts >= 1000
    attempts += 1
    root_i, root_j = find[i], find[j]
    next if root_i == root_j # déjà connectés
    if size[root_i] < size[root_j]
      parent[root_i] = root_j
      size[root_j] += size[root_i]
    else
      parent[root_j] = root_i
      size[root_i] += size[root_j]
    end    
  }

  result = (0...n).map { |i| find[i] }
    .tally # ==> Utils.count_occurrences mais impossible à utiliser seul
    .values
    .max(3) # top 3
    .reduce(:*) # ==> Utils.product mais compliqué d'utiliser ici seul
  
  puts result

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, result, cookie)
}

# Execution: 1.054816385 secondes

#!/usr/bin/env ruby 
# part2.rb
require_relative '../../utils.rb'

def count_paths_with_required(graph, start, target, required)
  # mask = 0b00 = aucun, 0b01 = dac, 0b10 = fft, 0b11 = les deux
  # c'est plus optimisé car grâce au bitmasking 
  # le Set ne devient plus qu'un simple entier !
  required_list = required.to_a
  cache = {}  
  recurse = lambda do |node, mask|
    return 1 if node == target && mask == (1 << required.size) - 1
    return 0 if node == target
    return 0 unless graph.key?(node)
    key = [node, mask]
    return cache[key] if cache.key?(key)
    new_mask = mask
    required_list.each_with_index do |request, index|
      new_mask |= (1 << index) if node == request
    end
    result = graph[node].sum { |neighbor| recurse.call(neighbor, new_mask) }
    cache[key] = result
    result
  end
  recurse.call(start, 0)
end

Utils.time {
  YEAR = 2025
  DAY = 11
  LEVEL = 2
  
  input = Utils.read_lines('day11-input.txt')
  graph = Utils.empty_graph
  input.each do |line|
    parts = line.split(':')
    from = parts[0].strip
    dest = parts[1].strip.split
    dest.each { |to| graph[from] << to }
  end
  good = Set.new(["dac", "fft"]) # les chemin doivent passer par ça
  sum = count_paths_with_required(graph, "svr", "out", good)
  
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}

# Execution: 0.440647801 secondes


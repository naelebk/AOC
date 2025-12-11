#!/usr/bin/env ruby 
# part1.rb
require_relative '../../utils.rb'


def count_paths(graph, start, target, cache = {})
  return cache[start] if cache.key?(start)
  return 1 if start == target
  return 0 unless graph.key?(start)
  total = graph[start].sum { |neighbor| count_paths(graph, neighbor, target, cache) }
  cache[start] = total
  total
end

Utils.time {
  YEAR = 2025
  DAY = 11
  LEVEL = 1
  
  input = Utils.read_lines('day11-input.txt')
  graph = Utils.empty_graph
  input.each do |line|
    parts = line.split(':')
    from = parts[0].strip
    dest = parts[1].strip.split
    dest.each { |to| graph[from] << to }
  end
  sum = count_paths(graph, "you", "out")

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}

# Execution: 0.480583528 secondes

#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

def parse_input(line)
  regex = /Valve ([A-Z]{2}) has flow rate=(\d+); tunnels? leads? to valves? (.+)/
  match = line.match(regex)
  return nil unless match
  [match[1], match[2].to_i, match[3].split(', ')]
end

def explore(current, time_left, opened, pressure, dist, rate, bit, best)
  best[opened] = pressure if pressure > (best[opened] || 0)
  dist[current].each do |target, d|
    next if opened & bit[target] != 0
    new_time = time_left - d - 1
    next if new_time <= 0
    explore(target, new_time, opened | bit[target], pressure + rate[target] * new_time, dist, rate, bit, best)
  end
end

Utils.time {
  YEAR = 2022
  DAY = 16
  LEVEL = 2
  START = 'AA'

  graph = Utils.empty_graph
  rate = {}

  Utils.read_lines('day16-input.txt').each do |line|
    parsed = parse_input(line)
    next unless parsed
    name, flow, tunnels = parsed
    rate[name] = flow
    tunnels.each { |t| graph[name] << t }
  end

  useful = rate.select { |_, flow| flow > 0 }.keys
  bit = {}
  useful.each_with_index { |name, i| bit[name] = 1 << i }
  dist = {}
  ([START] + useful).each do |from|
    distances = Utils.bfs_distances(graph, from)
    dist[from] = useful.reject do |to|
      to == from || !distances.key?(to)
    end.map do |to|
      [to, distances[to]]
    end.to_h
  end
  remaining_time = 26
  best = {}
  explore(START, remaining_time, 0, 0, dist, rate, bit, best)
  entries = best.to_a
  sum = 0
  Utils.loop_n_levels(entries.size, levels: 2) do |i, j|
    mask1, pressure1 = entries[i]
    mask2, pressure2 = entries[j]
    next if mask1 & mask2 != 0
    total = pressure1 + pressure2
    sum = total if total > sum
  end
  puts sum
  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 2.121123126 secondes
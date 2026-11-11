#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

def parse_input(line)
  regex = /Valve ([A-Z]{2}) has flow rate=(\d+); tunnels? leads? to valves? (.+)/
  match = line.match(regex)
  return nil unless match
  [match[1], match[2].to_i, match[3].split(', ')]
end

def search(current, time_left, opened, dist, rate, bit)
  best = 0
  dist[current].each do |target, d|
    next if opened & bit[target] != 0
    # d minutes de trajet + 1 minute pour ouvrir
    new_time = time_left - d - 1
    next if new_time <= 0
    gain = rate[target] * new_time
    total = gain + search(target, new_time, opened | bit[target], dist, rate, bit)
    best = total if total > best
  end
  best
end

Utils.time {
  YEAR = 2022
  DAY = 16
  LEVEL = 1
  START = 'AA'

  graph = Utils.empty_graph
  rate = {}
  Utils.read_lines('day16-input.txt').each do |line|
    parsed = parse_input(line)
    next unless parsed
    name, flow, tunnels = parsed
    rate[name] = flow
    tunnels.each do |t| graph[name] << t end
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
  remaining_time = 30
  sum = search(START, remaining_time, 0, dist, rate, bit)
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.700571259 secondes
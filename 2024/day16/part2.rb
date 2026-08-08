#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

CORRESPONDANCE = {
  0 => :RIGHT,
  1 => :DOWN,
  2 => :LEFT,
  3 => :UP
}

DIRECTIONS = {
  RIGHT: [0, 1],
  DOWN: [1, 0],
  LEFT: [0, -1],
  UP: [-1, 0],
}

Utils.time {
  YEAR = 2024
  DAY = 16
  LEVEL = 2

  grid = Utils.read_matrix('day16-input.txt')
  start = Utils.find_in_grid("S", grid)
  finish = Utils.find_in_grid("E", grid)
  height, width = Utils.get_size_of_grid(grid)

  graph = Utils.empty_weighted_graph
  reverse_graph = Utils.empty_weighted_graph

  grid.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      next if cell == "#"
      (0..3).each do |d|
        node = [y, x, d]
        dy, dx = DIRECTIONS[CORRESPONDANCE[d]]
        ny, nx = y + dy, x + dx
        if Utils.in_bounds?(nx, ny, width, height) && grid[ny][nx] != "#"
          graph[node][[ny, nx, d]] = 1
          reverse_graph[[ny, nx, d]][node] = 1
        end
        [(d + 1) % 4, (d + 3) % 4].each do |nd|
          graph[node][[y, x, nd]] = 1000
          reverse_graph[[y, x, nd]][node] = 1000
        end
      end
    end
  end

  start_state = [start[0], start[1], 0]
  (0..3).each do |d|
    graph[[finish[0], finish[1], d]][:end] = 0
    reverse_graph[:end][[finish[0], finish[1], d]] = 0
  end

  dist_from_start = Utils.full_dijkstra(graph, start_state)
  dist_to_end = Utils.full_dijkstra(reverse_graph, :end)

  best_score = dist_from_start[:end]

  tiles = Set.new
  grid.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      next if cell == "#"
      (0..3).each do |d|
        state = [y, x, d]
        next if dist_from_start[state] == Float::INFINITY
        next if dist_to_end[state] == Float::INFINITY
        tiles << [y, x] if dist_from_start[state] + dist_to_end[state] == best_score
      end
    end
  end

  sum = tiles.size
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 1.15172855 secondes
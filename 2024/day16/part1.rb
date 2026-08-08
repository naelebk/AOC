#!/usr/bin/env ruby
# part1.rb
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
  LEVEL = 1

  grid = Utils.read_matrix('day16-input.txt')
  start = Utils.find_in_grid("S", grid)
  finish = Utils.find_in_grid("E", grid)
  height, width = Utils.get_size_of_grid(grid)

  # on doit construire un graphe pondéré (1 droit, 1000 virage 90°) pour appliquer l'algorithme de Dijkstra
  graph = Utils.empty_weighted_graph
  grid.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      next if cell == "#"
      (0..3).each do |d|
        node = [y, x, d]
        dy, dx = DIRECTIONS[CORRESPONDANCE[d]]
        ny, nx = y + dy, x + dx
        graph[node][[ny, nx, d]] = 1 if Utils.in_bounds?(nx, ny, width, height) && grid[ny][nx] != "#"
        graph[node][[y, x, (d + 1) % 4]] = 1000
        graph[node][[y, x, (d + 3) % 4]] = 1000
      end
    end
  end
  start_state = [start[0], start[1], 0]
  (0..3).each { |d| graph[[finish[0], finish[1], d]][:end] = 0 }

  sum = Utils.dijkstra(graph, start_state, :end)

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 1.053264817 secondes 
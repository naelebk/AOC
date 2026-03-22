#!/usr/bin/env ruby 
# part2.rb
require_relative '../../utils.rb'

CANALISATIONS = ['|', '-', 'L', 'J', '7', 'F']
CONNECTIONS = {
  '|' => [[-1,0], [1,0]], # nord, sud
  '-' => [[0,-1], [0,1]], # ouest, est
  'L' => [[-1,0], [0,1]], # nord, est
  'J' => [[-1,0], [0,-1]], # nord, ouest
  '7' => [[1,0],  [0,-1]], # sud, ouest
  'F' => [[1,0],  [0,1]] # sud, est
}

def find_start_of_grid(grid)
  grid.each_with_index do |line, i|
    line.each_with_index do |element, j|
      return [i, j] if element == 'S'
    end
  end
  nil
end

def find_first_neighbor(grid, start_coords)
  sx, sy = start_coords
  Utils.neighbors4(0, 0).each do |x, y|
    nx, ny = sx + x, sy + y
    next unless grid[nx] && grid[nx][ny]
    element = grid[nx][ny]
    next unless CONNECTIONS[element]
    return [nx, ny] if CONNECTIONS[element].any? { |d| [nx + d[0], ny + d[1]] == start_coords }
  end
end

def determine_s_symbol(start_coords, first_neighbor, last_neighbor)
  sx, sy = start_coords
  dirs = [
    [first_neighbor[0]-sx, first_neighbor[1]-sy],
    [last_neighbor[0]-sx,  last_neighbor[1]-sy]
  ].sort
  CONNECTIONS.find { |_, v| v.sort == dirs }&.first
end

def process(grid, start_coords)
  previous = start_coords
  current = find_first_neighbor(grid, start_coords)
  nb_pas = 1
  loop_nodes = Set.new([start_coords])
  first_neighbor = current

  loop do
    loop_nodes << current
    return [nb_pas / 2, loop_nodes, first_neighbor, previous] if current == start_coords
    element = grid[current[0]][current[1]]
    directions = CONNECTIONS[element]
    neighbors = directions.map { |d| [current[0]+d[0], current[1]+d[1]] }
    next_coord = neighbors.find { |n| n != previous }
    previous = current
    current = next_coord
    nb_pas += 1
  end
end

def count_inside(grid, loop_nodes, s_symbol)
  count = 0
  grid.each_with_index do |line, i|
    crossings = 0
    last_bend = nil
    line.each_with_index do |cell, j|
      tile = loop_nodes.include?([i,j]) ? (cell == 'S' ? s_symbol : cell) : nil
      if tile
        case tile
        when '|' then crossings += 1
        when 'F', 'L' then last_bend = tile
        when 'J'
          crossings += 1 if last_bend == 'F'
          last_bend = nil
        when '7'
          crossings += 1 if last_bend == 'L'
          last_bend = nil
        end
      else
        count += 1 if crossings.odd?
      end
    end
  end
  count
end

Utils.time {
  YEAR = 2023
  DAY = 10
  LEVEL = 2

  input = Utils.read_matrix('day10-input.txt')
  start_coords = find_start_of_grid(input)
  _, loop_nodes, first_neighbor, last_neighbor = process(input, start_coords)
  s_symbol = determine_s_symbol(start_coords, first_neighbor, last_neighbor)
  sum = count_inside(input, loop_nodes, s_symbol)

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.480937031 secondes

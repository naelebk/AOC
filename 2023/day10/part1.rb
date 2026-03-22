#!/usr/bin/env ruby 
# part1.rb
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

def process(grid, start_coords)
  previous = start_coords
  current = find_first_neighbor(grid, start_coords)
  nb_pas = 1

  loop do
    return nb_pas / 2 if current == start_coords
    element = grid[current[0]][current[1]]
    directions = CONNECTIONS[element]
    neighbors = directions.map { |d| [current[0]+d[0], current[1]+d[1]] }
    next_coord = neighbors.find { |n| n != previous }
    previous = current
    current = next_coord
    nb_pas += 1
  end
end


Utils.time {
  YEAR = 2023
  DAY = 10
  LEVEL = 1

  input = Utils.read_matrix('day10-input.txt')
  sum = process(input, find_start_of_grid(input))
  puts sum  
  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.509843833 secondes

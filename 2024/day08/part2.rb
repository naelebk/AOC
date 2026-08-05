#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

def count_unique_location(grid)
  height, width = Utils.get_size_of_grid(grid)
  antennae = {}
  grid.each_with_index do |row, i|
    row.each_with_index do |element, j|
      next if element == '.'
      antennae[element] ||= []
      antennae[element] << [i, j]
    end
  end
  
  antinodes = Set.new
  
  antennae.each do |frequency, positions|
    positions.combination(2) do |pos1, pos2|
      i1, j1 = pos1
      i2, j2 = pos2
      
      di = i2 - i1
      dj = j2 - j1
      
      ai, aj = i1, j1
      while ai >= 0 && ai < height && aj >= 0 && aj < width
        antinodes.add([ai, aj])
        ai += di
        aj += dj
      end
      
      ai, aj = i1, j1
      while ai >= 0 && ai < height && aj >= 0 && aj < width
        antinodes.add([ai, aj])
        ai -= di
        aj -= dj
      end
    end
  end
  antinodes.size
end

Utils.time {
  YEAR = 2024
  DAY = 8
  LEVEL = 2

  input = Utils.read_matrix('day08-input.txt')
  sum = count_unique_location(input)

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.667147447 secondes

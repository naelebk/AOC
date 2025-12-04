#!/usr/bin/env ruby 
# part1.rb
require_relative '../../utils.rb'

def is_symbol(ch)
  !Utils.is_digit?(ch) && ch != '.'
end

Utils.time {
  YEAR = 2023
  DAY = 3
  LEVEL = 1

  grid = Utils.read_matrix('day3-input.txt')
  width = grid.size
  height = grid[0].size
  sum = 0
  current = ""
  touches_symbol = false

  grid.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      if Utils.is_digit?(cell)
        current << cell
        Utils.neighbors8(x, y).each do |nx, ny|
          next unless Utils.in_bounds?(nx, ny, width, height)
          touches_symbol = true if is_symbol(grid[ny][nx])
        end
      elsif !current.empty?
        sum += current.to_i if touches_symbol
        current = ""
        touches_symbol = false
      end

    end
    if !current.empty?
      sum += current.to_i if touches_symbol
      current = ""
      touches_symbol = false
    end
  end

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}

# Execution: 0.749211396 secondes

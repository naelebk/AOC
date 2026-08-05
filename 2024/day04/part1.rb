#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

WORD = "XMAS"
DIRECTIONS = Utils.neighbors8(0,0)

def find_xmas_in_matrix(matrix)
  height, width = Utils.get_size_of_grid(matrix)
  word_len = WORD.length
  count = 0
  (0...height).each do |row|
    (0...width).each do |col|
      next unless matrix[row][col] == WORD[0]
      DIRECTIONS.each do |d_row, d_col|
        end_r = row + d_row * (word_len - 1)
        end_c = col + d_col * (word_len - 1)
        next unless end_r.between?(0, height - 1) && end_c.between?(0, width - 1)
        match = (1...word_len).all? do |i|
          matrix[row + d_row * i][col + d_col * i] == WORD[i]
        end
        count += 1 if match
      end
    end
  end
  count
end

Utils.time {
  YEAR = 2024
  DAY = 04
  LEVEL = 1

  matrix = Utils.read_matrix('day04-input.txt')
  sum = find_xmas_in_matrix(matrix)

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.629426139 secondes
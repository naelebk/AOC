#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

WORD = "XMAS"
DIRECTIONS = Utils.neighbors8(0,0)

def find_xmas_in_matrix(matrix)
  height, width = Utils.get_size_of_grid(matrix)
  count = 0
  # on évite les bords car le 'A' doit être au centre d'une croix 3x3
  (1...(height - 1)).each do |row|
    (1...(width - 1)).each do |col|
      next unless matrix[row][col] == 'A'
      diag1 = matrix[row - 1][col - 1] + matrix[row + 1][col + 1]
      diag2 = matrix[row - 1][col + 1] + matrix[row + 1][col - 1]
      count += 1 if (diag1 == "MS" || diag1 == "SM") && (diag2 == "MS" || diag2 == "SM")
    end
  end
  count
end

Utils.time {
  YEAR = 2024
  DAY = 04
  LEVEL = 2

  input = Utils.read_matrix('day04-input.txt')
  sum = find_xmas_in_matrix(input)

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.695961352 secondes

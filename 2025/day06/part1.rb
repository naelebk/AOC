#!/usr/bin/env ruby 
# part1.rb
require_relative '../../utils.rb'

def read_columns(path)
  Utils.read_lines(path).map do |line|
    line.split.map do |word|
      if word.length != 1 || word.chars.all? { |c| c.match?(/\d/) }
        word.to_i
      else
        word
      end
    end
  end.transpose
end

Utils.time {
  YEAR = 2025
  DAY = 6
  LEVEL = 1

  sum = 0
  columns = read_columns("day6-input.txt")
  columns.each do |column|
    symbol = column.pop
    if symbol == "+"
      sum += column.sum
    elsif symbol == "*"
      sum += Utils.product(column)
    end
  end

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}

# Execution: 0.424442419 secondes

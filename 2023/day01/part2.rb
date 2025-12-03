#!/usr/bin/env ruby 
# part2.rb
require_relative '../../utils.rb'

def extract_all_digits(line, correspondance)
  pattern = /(?=(#{correspondance.keys.join("|")}|\d))/
  matches = line.scan(pattern).flatten
  matches.map { |match| correspondance[match] || match.to_i }
end

Utils.time {
  YEAR = 2023
  DAY = 1
  LEVEL = 2

  input = Utils.read_lines('day1-input.txt')
  sum = 0
  english_digits = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
  correspondance = {}
  english_digits.each_with_index do |element, index|
    correspondance[element] = index + 1
  end
  input.each do |line|
    digits = extract_all_digits(line, correspondance)
    number = digits.first * 10 + digits.last
    sum += number
  end

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}

# Execution: 0.812078493 secondes

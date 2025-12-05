#!/usr/bin/env ruby 
# part2.rb
require_relative '../../utils.rb'

Utils.time {
  YEAR = 2023
  DAY = 4
  LEVEL = 2

  input = Utils.read_lines('day4-input.txt')
  copies = Array.new(input.size, 1) # exemplaires des index des cartes gagnantes
  
  input.each_with_index do |line, i|
    card_index, numbers = line.split(':')
    left, right = numbers.split('|').map(&:strip)
    left = left.split(' ').map(&:to_i)
    right = right.split(' ').map(&:to_i)

    winning_count = left.reject {|num|
      !right.include?(num)
    }.size
    
    copies[i].times do
      (1..winning_count).each do |j|
        next_card_index = i + j
        break if next_card_index >= input.size
        copies[next_card_index] += 1
      end
    end
  end

  sum = copies.sum
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}

# Execution: 2.079821137 secondes
# Pas ma version la plus opti... clairement...
# Mais au moins, elle fonctionne !

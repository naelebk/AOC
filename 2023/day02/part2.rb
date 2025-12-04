#!/usr/bin/env ruby 
# part2.rb
require_relative '../../utils.rb'

def product(game)
  informations = game.split(':')
  game_id = informations[0].match(/\d+/)[0].to_i
  draws = informations[1].split(';').map(&:strip)
  colors = ["red", "green", "blue"]
  current_information = {
    "red" => 0,
    "green" => 0,
    "blue" => 0
  }
  draws.each do |draw|
    cubes = draw.split(',').map(&:strip)
    cubes.each do |cube|
      parts = cube.split(' ')
      number = parts[0].to_i
      color = parts[1]  
      current_information[color] = number if number > current_information[color]
    end
  end
  product = 1
  colors.each do |color|
    product *= current_information[color]
  end
  product
end

Utils.time {
  YEAR = 2023
  DAY = 2
  LEVEL = 2

  input = Utils.read_lines('day2-input.txt')
  sum = 0
  input.each do |game|
    sum += product(game)
  end

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}

# Execution: 0.952950605 secondes

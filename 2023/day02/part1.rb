#!/usr/bin/env ruby 
# part1.rb
require_relative '../../utils.rb'

def is_valid_game(game, max)
  informations = game.split(':')
  game_id = informations[0].match(/\d+/)[0].to_i
  draws = informations[1].split(';').map(&:strip)
  colors = ["red", "green", "blue"]
  draws.each do |draw|
    current_information = {
      "red" => 0,
      "green" => 0,
      "blue" => 0
    }
    cubes = draw.split(',').map(&:strip)
    cubes.each do |cube|
      parts = cube.split(' ')
      number = parts[0].to_i
      color = parts[1]      
      current_information[color] += number
    end
    colors.each do |color|
      return 0 if current_information[color] > max[color]
    end
  end
  game_id
end

Utils.time {
  YEAR = 2023
  DAY = 2
  LEVEL = 1

  max = {
   "red" => 12,
   "green" => 13,
   "blue" => 14
  }

  input = Utils.read_lines('day2-input.txt')
  sum = 0
  input.each do |game|
    sum += is_valid_game(game, max)
  end

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}

# Execution: 0.985958706 secondes

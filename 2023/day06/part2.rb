#!/usr/bin/env ruby 
# part2.rb
require_relative '../../utils.rb'

def second_degre(a, b, c)
  return [] if a == 0
  delta = b * b - 4 * a * c
  return [] if delta < 0
  return [-(b/(2.0*a))] if delta == 0
  [(-b - Math.sqrt(delta))/ (2.0 * a), (-b + Math.sqrt(delta))/ (2.0 * a)]
end

def calculate_nb_ways_to_win(course)
  time, record_distance = course
  roots = second_degre(-1, time, -record_distance)
  return 0 if roots.empty?
  x1, x2 = roots.sort
  borne_min = x1 == x1.ceil ? x1.to_i + 1 : x1.ceil
  borne_max = x2 == x2.floor ? x2.to_i - 1 : x2.floor
  [borne_max - borne_min + 1, 0].max
end

Utils.time {
  YEAR = 2023
  DAY = 6
  LEVEL = 2

  input = Utils.read_csv('day6-input.txt', ':')
  arr = []
  input.each do |line|
    first, second = line
    arr << second.split.join('')
  end
  arr.map!(&:to_i)
  
  sum = calculate_nb_ways_to_win(arr)

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}

# Execution: 0.807228805 secondes

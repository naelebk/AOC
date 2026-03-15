#!/usr/bin/env ruby 
# part1.rb
require_relative '../../utils.rb'

def second_degre(a, b, c)
  return [] if a == 0
  delta = b * b - 4 * a * c
  return [] if delta < 0
  return [-(b/2*a)] if delta == 0
  [(-b - Math.sqrt(delta))/ (2 * a), (-b + Math.sqrt(delta))/ (2 * a)]
end

def calculate_nb_ways_to_win(course)
  time, record_distance = course
  roots = second_degre(-1, time, -record_distance)
  return 0 if roots.empty?
  x1, x2 = roots.sort
  borne_min = (x1 + 0.000000001).ceil
  borne_max = (x2 - 0.000000001).floor
  [borne_max - borne_min + 1, 0].max
end

Utils.time {
  YEAR = 2023
  DAY = 6
  LEVEL = 1

  input = Utils.read_csv('day6-input.txt', ':')
  arr = []
  input.each do |line|
    first, second = line
    arr << second.split.map!(&:to_i)
  end
  arr = arr.transpose
  sum = 1
  arr.each do |element|
    sum *= calculate_nb_ways_to_win(element)
  end

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}

# Execution: 0.518620607 seconde

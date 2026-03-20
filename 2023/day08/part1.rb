#!/usr/bin/env ruby 
# part1.rb
require_relative '../../utils.rb'

def run(graph, directions, start, goal)
  current = start
  directions.cycle.each_with_index do |dir, i|
    current = dir == 'L' ? graph[current][0] : graph[current][1]
    return i + 1 if current == goal
  end
end

Utils.time {
  YEAR = 2023
  DAY = 8
  LEVEL = 1
  input = Utils.read_lines('day8-input.txt')
  directions = input[0].split('')
  2.times do
    input.shift
  end  
  graph = {}
  input.each do |element|
    left, right = element.split('=').map { |e| e.strip }
    next if left.nil? || right.nil?
    right = right.split(',').map { |e| e.strip.gsub(')', '').gsub('(', '') }
    graph[left] = right
  end

  sum = run(graph, directions, 'AAA', 'ZZZ')
  puts sum
  
  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.915716097 secondes

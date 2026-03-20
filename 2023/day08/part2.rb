#!/usr/bin/env ruby 
# part2.rb
require_relative '../../utils.rb'

def end_with_z(element)
  element.split('')[-1] == 'Z'
end

def start_with_a(element)
  element.split('')[-1] == 'A'
end

def run(graph, directions, start)
  current = start
  directions.cycle.each_with_index do |dir, i|
    current = dir == 'L' ? graph[current][0] : graph[current][1]
    return i + 1 if end_with_z(current)
  end
end

Utils.time {
  YEAR = 2023
  DAY = 8
  LEVEL = 2

  input = Utils.read_lines('day8-input.txt')
  directions = input[0].split('')
  2.times do
    input.shift
  end  
  graph = {}
  starts = []
  input.each do |element|
    left, right = element.split('=').map { |e| e.strip }
    next if left.nil? || right.nil?
    right = right.split(',').map { |e| e.strip.gsub(')', '').gsub('(', '') }
    graph[left] = right
    starts << left if start_with_a(left)
  end

  cycles = starts.map do |s|
    run(graph, directions, s)
  end
  sum = cycles.reduce(1) do |acc, c|
    acc.lcm(c)
  end

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}

# Execution: 0.805592796 secondes

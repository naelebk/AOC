#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

Utils.time {
  YEAR = 2024
  DAY = 23
  LEVEL = 1

  graph = Utils.read_graph('day23-input.txt')
  visited = Set.new
  graph.each_key do |key|
    neighbors = graph[key].to_a
    neighbors.combination(2).each do |second, third|
      next unless graph[second].include?(third)
      visited.add([key, second, third].sort)
    end
  end

  sum = visited.select { |visit| visit.any? { |n| n.start_with?("t") } }.size
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.702366289 secondes

#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

Utils.time {
  YEAR = 2024
  DAY = 23
  LEVEL = 2

  graph = Utils.read_graph('day23-input.txt')
  sum = Utils.max_clique(graph).sort.join(',')
  
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.680803671 secondes

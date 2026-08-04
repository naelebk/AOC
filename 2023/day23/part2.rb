#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

DEPART = "S"
ARRIVEE = "A"

Utils.time {
  YEAR = 2023
  DAY = 23
  LEVEL = 2

  input = Utils.read_matrix('day23-input.txt')
  size = input.size
  input[0] = input[0].map { |el| el == '.' ? DEPART : el }
  input[size - 1] = input[size - 1].map { |el| el == '.' ? ARRIVEE : el }

  start = [input[0].index(DEPART), 0]
  goal = [input[size - 1].index(ARRIVEE), size - 1]

  graph = Utils.matrix_to_graph(
    input,
    passable: ->(cell) { cell != '#' },
    directions: ->(cell) { Utils.neighbors4(0, 0) }
  )

  sum = Utils.longest_path(
    Utils.compress_graph(
      graph,
      keep: [start, goal]
    ),
    start,
    goal
  )
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 8.372795482 secondes
# Pas ma version la plus optimisée, mais j'avais la flemme de changer tout mon code...
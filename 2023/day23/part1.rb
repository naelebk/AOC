#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

DEPART = "S"
ARRIVEE = "A"

SLOPE = {
  ">" => [[1, 0]],
  "<" => [[-1, 0]],
  "v" => [[0, 1]],
  "^" => [[0, -1]]
}

Utils.time {
  YEAR = 2023
  DAY = 23
  LEVEL = 1

  input = Utils.read_matrix('day23-input.txt')
  size = input.size
  input[0] = input[0].map { |el| el == '.' ? DEPART : el }
  input[size - 1] = input[size - 1].map { |el| el == '.' ? ARRIVEE : el }

  start = [input[0].index(DEPART), 0]
  goal = [input[size - 1].index(ARRIVEE), size - 1]

  graph = Utils.matrix_to_graph(
    input,
    passable: ->(cell) { cell != '#' },
    directions: ->(cell) { SLOPE[cell] || Utils.neighbors4(0, 0) }
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
# Execution: 0.624601303 secondes
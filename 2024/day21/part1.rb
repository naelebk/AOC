#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

NUM_PAD = [
  ['', '0', 'A'],
  ['1', '2', '3'],
  ['4', '5', '6'],
  ['7', '8', '9']
]

KEY_PAD = [
  ['<', 'v', '>'],
  ['', '^', 'A']
]

ROBOT_COUNT = 2
DIR_GRAPH = Utils.build_graph(KEY_PAD)
NUM_GRAPH = Utils.build_graph(NUM_PAD)
CANDIDATES = {}

def code_value(c) = c.gsub(/[A-Za-z\-]/, '').to_i
def complexity(c, length) = code_value(c) * length

def direction(from, to)
  dy = to[0] - from[0]
  dx = to[1] - from[1]
  return '>' if dx == 1
  return '<' if dx == -1
  return '^' if dy == 1
  'v'
end


def candidates(from, to, grid, graph)
  return CANDIDATES[[from, to, grid.object_id]] if CANDIDATES[[from, to, grid.object_id]]
  Utils.all_shortest_paths(graph, from, to).map { |path|
    path.each_cons(2).map { |a, b|
      direction(Utils.find_in_grid(a, grid), Utils.find_in_grid(b, grid)) 
    }.join + 'A'
  }
end

def min_len(seq, depth, memo)
  return seq.size if depth.zero?
  memo[[seq, depth]] ||= ('A' + seq).each_char.each_cons(2).sum do |a, b|
    candidates(a, b, KEY_PAD, DIR_GRAPH).map { |c|
      min_len(c, depth - 1, memo) 
    }.min
  end
end

def solve_code(c, memo)
  ('A' + c).each_char.each_cons(2).sum do |a, b|
    candidates(a, b, NUM_PAD, NUM_GRAPH).map { 
      |seq| min_len(seq, ROBOT_COUNT, memo) 
    }.min
  end
end

Utils.time {
  YEAR = 2024
  DAY = 21
  LEVEL = 1

  codes = Utils.read_matrix("day21-input.txt").map(&:join)
  memo = {}
  sum = codes.sum { |c| complexity(c, solve_code(c, memo)) }
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.670686787 secondes
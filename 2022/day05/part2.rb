#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

# On en parle de ce parsing de merde ?
def parse_stacks(lines)
  lines = lines.dup
  numbers_line = lines.pop
  labels = Utils.parse_ints(numbers_line)
  stacks = Hash.new { |h, k| h[k] = [] }
  lines.reverse_each do |line|
    labels.each do |label|
      index = 1 + (label - 1) * 4
      crate = line[index]
      stacks[label] << crate if crate && crate != " "
    end
  end
  stacks
end
 
def parse_moves(lines) = lines.map { |line| Utils.parse_ints(line) }

def do_move(move, stacks)
  number, from, to = move
  new_stacks = stacks.dup
  (0...number).each do |i|
    size = new_stacks[from].size
    to_move = new_stacks[from][size - number + i]
    next if to_move.nil?
    new_stacks[from].delete_at(size - number + i)
    new_stacks[to].push(to_move)
  end
  new_stacks
end

Utils.time {
  YEAR = 2022
  DAY = 5
  LEVEL = 2

  stacks, moves = Utils.read_blocks("day05-input.txt")
  stacks = parse_stacks(stacks)
  moves = parse_moves(moves)
  
  moves.each { |move| stacks = do_move(move, stacks) }
  sum = ""
  stacks.each_value { |value| sum += value.last }
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.618717877 secondes

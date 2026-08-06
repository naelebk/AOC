#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

TO_ADD = 10000000000000
TOKEN_A = 3
TOKEN_B = 1

def count_token(line)
  a, b, prize = line
  xa, ya = a
  xb, yb = b
  x, y = prize
  x += TO_ADD
  y += TO_ADD

  det = xa * yb - ya * xb
  # si le déterminant est nul il n'y a pas de solution
  return 0 if det == 0

  det_nb1 = x * yb - y * xb
  det_nb2 = xa * y - ya * x
  if det_nb1 % det == 0 && det_nb2 % det == 0
    nb1 = det_nb1 / det
    nb2 = det_nb2 / det
    return nb1 * TOKEN_A + nb2 * TOKEN_B if nb1 >= 0 && nb2 >= 0
  end
  0
end

Utils.time {
  YEAR = 2024
  DAY = 13
  LEVEL = 2

  # Les gars par contre le parsing...
  input = Utils.read_blocks('day13-input.txt').map { |line|
    line.map { |l|
      l.split(':')[1..].map {
        |ll| ll.strip
      }
    }
  }.map do |a,b,prize|
    [
      Utils.parse_ints(a.first),
      Utils.parse_ints(b.first),
      Utils.parse_ints(prize.first)
    ]
  end

  sum = input.sum { |line| count_token(line) }

  puts sum 

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 1.029476634 secondes

#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

def compare(left, right)
  return left <=> right if left.is_a?(Integer) && right.is_a?(Integer)
  left = [left] if left.is_a?(Integer)
  right = [right] if right.is_a?(Integer)
  left.zip(right).each do |l, r|
    return 1 if r.nil?
    result = compare(l, r)
    return result unless result.zero?
  end
  left.size <=> right.size
end

Utils.time {
  YEAR = 2022
  DAY = 13
  LEVEL = 1

  input = Utils.read_blocks("day13-input.txt").map { |array|
    array.map { |a| eval(a) }
  }
  sum = input.each_with_index.sum { |pair, i| compare(pair[0], pair[1]) < 0 ? i+1 : 0 }
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.003447445 secondes

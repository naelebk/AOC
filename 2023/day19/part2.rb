#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

def parse_piece(piece)
  piece
  .gsub('{', '')
  .gsub('}', '')
  .split(',').map { 
    |i| i.split('=') 
  }.map { |key, value|
    [key, value.to_i] 
  }.to_h
end

def count_accepted(flows, current, ranges)
  return 0 if current == "R"
  return ranges.values.map { |min, max| max - min + 1 }.reduce(:*) if current == "A"
  workflow = flows.find { |f| f.start_with?("#{current}{") }
  rules = workflow.gsub('}', '').split('{')[1].split(',')
  total = 0
  remaining = ranges.dup
  rules.each do |rule|
    if rule.include?(':')
      var, op, val, dest = rule.split(/([<>])/).then { |a, o, rest| [a, o, *rest.split(':')] }
      val = val.to_i
      min, max = remaining[var]
      matched, unmatched = if op == '<'
        [[min, [max, val - 1].min], [[min, val].max, max]]
      else
        [[[min, val + 1].max, max], [min, [max, val].min]]
      end
      if matched[0] <= matched[1]
        new_ranges = remaining.merge({ var => matched })
        total += count_accepted(flows, dest, new_ranges)
      end
      break unless unmatched[0] <= unmatched[1]
      remaining = remaining.merge({ var => unmatched })
    else
      total += count_accepted(flows, rule, remaining)
    end
  end
  total
end


Utils.time {
  YEAR = 2023
  DAY = 19
  LEVEL = 2

  flows, pieces = Utils.read_blocks('day19-input.txt')
  initial_ranges = {
    'x' => [1, 4000],
    'm' => [1, 4000],
    'a' => [1, 4000],
    's' => [1, 4000]
  }
  sum = count_accepted(flows, "in", initial_ranges)

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.422647818 secondes

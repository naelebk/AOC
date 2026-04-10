#!/usr/bin/env ruby
# part1.rb
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

def evaluate(flows, piece)
  part = parse_piece(piece)
  current = "in"
  loop do
    return 0 if current == "R"
    return part.values.sum if current == "A"
    workflow = flows.find { |f| f.start_with?("#{current}{") }
    rules = workflow.gsub('}', '').split('{')[1].split(',')
    current = rules.each do |rule|
      if rule.include?(':')
        var, op, val, dest = rule.split(/([<>]):?/).then { |a, o, rest| [a, o, *rest.split(':')] }
        part_val = part[var]
        matched = op == '<' ? part_val < val.to_i : part_val > val.to_i
        break dest if matched
      else
        break rule
      end
    end
  end
end

Utils.time {
  YEAR = 2023
  DAY = 19
  LEVEL = 1

  flows, pieces = Utils.read_blocks('day19-input.txt')
  sum = pieces.sum do |piece|
    evaluate(flows, piece)
  end

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.575784229 secondes

#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

def try_operations(current, remaining, target)
  return current == target if remaining.empty?
  next_val = remaining[0]
  rest = remaining[1..]
  try_operations(current + next_val, rest, target) ||
  try_operations(current * next_val, rest, target) ||
  try_operations((current.to_s + next_val.to_s).to_i, rest, target)
end

def operation_possible?(hash)
  expected_result = hash.keys.first
  values = hash[expected_result]
  return false if values.empty?
  return expected_result == values[0] if values.size == 1
  try_operations(values[0], values[1..], expected_result)
end

Utils.time {
  YEAR = 2024
  DAY = 07
  LEVEL = 2

  input = Utils.read_csv("day07-input.txt", ':').map do |key, value|
    {key.to_i => value.split(' ').map(&:to_i)}
  end
  sum = input.sum do |hash|
    operation_possible?(hash) ? hash.keys.first : 0
  end

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 2.269340583 secondes

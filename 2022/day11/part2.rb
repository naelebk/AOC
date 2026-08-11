#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

LIMIT = 10000

Monkey = Struct.new(:items, :op, :op_val, :test, :t_true, :t_false, :inspected) do
  def initialize(*)
    super
    self.inspected = 0
  end
end

Utils.time {
  YEAR = 2022
  DAY = 11
  LEVEL = 2

  input = Utils.read_lines("day11-input.txt")
  monkeys = []
  input.each_slice(7) do |line|
    _, items, op_str, test, t_true, t_false = line.map(&:strip)
    items = items.scan(/\d+/).map(&:to_i)
    op = op_str.scan(/\*|\+/).first
    op_val = op_str.scan(/\d+/).first
    if op_val.nil?
      op = "**"
      op_val = 2
    else
      op_val = op_val.to_i
    end
    test = test.scan(/\d+/).first.to_i
    t_true = t_true.scan(/\d+/).first.to_i
    t_false = t_false.scan(/\d+/).first.to_i
    monkeys << Monkey.new(items, op, op_val, test, t_true, t_false)
  end

  divisor = monkeys.map(&:test).inject(&:*)
  LIMIT.times do |i|
    monkeys.each do |monkey|
      monkey.items.each do |item|
        monkey.inspected += 1
        worry = item.send(monkey.op, monkey.op_val) % divisor
        if worry % monkey.test == 0
          monkeys[monkey.t_true].items << worry
        else
          monkeys[monkey.t_false].items << worry
        end
      end
      monkey.items = []
    end
  end

  sum = monkeys.map(&:inspected).sort.last(2).inject(&:*)
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.030654337 secondes

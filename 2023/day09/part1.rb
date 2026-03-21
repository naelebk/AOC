#!/usr/bin/env ruby 
# part1.rb
require_relative '../../utils.rb'

def build_sequences(sequence)
  sequences = [sequence]
  loop do
    current = sequences.last
    break if current.all?(&:zero?)
    sequences << current.each_cons(2).map { |a, b| b - a }
  end
  sequences
end

def extrapolate(sequences)
  sequences.reverse.reduce(0) { |acc, seq| seq.last + acc }
end

Utils.time {
  YEAR = 2023
  DAY = 9
  LEVEL = 1

  input = Utils.read_csv('day9-input.txt', ' ').map do |tab|
    tab.map!(&:to_i)
  end

  sum = input.sum do |sequence|
    next if sequence.nil? || sequence.empty?
    sequences = build_sequences(sequence)
    extrapolate(sequences)
  end

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.678251219 secondes

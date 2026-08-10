#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

LIMIT = 2000
MODULO = 16777216

def next_secret(secret)
  secret ^= secret * 64
  secret %= MODULO
  secret ^= secret / 32
  secret %= MODULO
  secret ^= secret * 2048
  secret %= MODULO
  secret
end

def generate_prices(number)
  secret = number
  prices = [number % 10]
  LIMIT.times {
    secret = next_secret(secret)
    prices << secret % 10
  }
  prices
end

def generate_sequence_prices(prices)
  variations = prices.each_cons(2).map { |a, b| b - a }
  sequence_prices = {}
  variations.each_cons(4).with_index { |seq, i|
    next if sequence_prices.key?(seq)
    sequence_prices[seq] = prices[i + 4]
  }
  sequence_prices
end

def solve(numbers)
  totals = Hash.new(0)
  numbers.each { |number|
    prices = generate_prices(number)
    sequence_prices = generate_sequence_prices(prices)
    sequence_prices.each { |seq, price| totals[seq] += price }
  }
  totals.values.max
end

Utils.time {
  YEAR = 2024
  DAY = 22
  LEVEL = 2

  numbers = Utils.read_numbers("day22-input.txt")
  sum = solve(numbers)

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 5.010710767 secondes

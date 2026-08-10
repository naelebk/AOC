#!/usr/bin/env ruby
# part1.rb
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

def generate_price(number)
  secret = number
  LIMIT.times { secret = next_secret(secret) }
  secret
end

Utils.time {
  YEAR = 2024
  DAY = 22
  LEVEL = 1

  numbers = Utils.read_numbers("day22-input.txt")
  sum = numbers.sum { |number| generate_price(number) }

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.929503889 secondes

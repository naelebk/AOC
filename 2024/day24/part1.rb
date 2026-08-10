#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

def bin(int) = int.to_i(2)

def do_operation(a, operation, b)
  case operation
  when "AND"
    return a & b
  when "XOR"
    return a ^ b
  when "OR"
    return a | b
  end
  0
end

def simulate(gates_list, gates_values)
  new_gates = {}
  size = gates_list.size
  while new_gates.size != size
    gates_list.each { |a, operation, b, result|
      next if new_gates.key?(result)
      next unless gates_values.key?(a)
      next unless gates_values.key?(b)
      resultat = do_operation(gates_values[a], operation, gates_values[b])
      new_gates[result] = resultat
      gates_values[result] = resultat
    }
  end
  bin(new_gates.select { |key, _| key[0] == 'z' }.sort.reverse.to_h.values.join)
end

Utils.time {
  YEAR = 2024
  DAY = 24
  LEVEL = 1

  gates_values, gates_list = Utils.read_blocks('day24-input.txt')
  # un peu chiant le parsing...
  gates_values = gates_values.map { |gv| 
    gv.split(':').map(&:strip) 
  }.map { |key, value| [key, value.to_i] }.to_h
  gates_list = gates_list.map { |gl| gl.split("->") }.map { |a,b| a.split(' ').map(&:strip) + [b.strip] }

  sum = simulate(gates_list, gates_values)
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.865306576 secondes

#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

def get_combo_value(operand, a, b, c)
  case operand
  when 0..3 then operand
  when 4 then a
  when 5 then b
  when 6 then c
  end
end

def execute_program(reg_a, reg_b, reg_c, program)
  output = []
  ip = 0
  while ip < program.length
    opcode = program[ip]
    operand = program[ip + 1]

    case opcode
    when 0 # adv
      combo = get_combo_value(operand, reg_a, reg_b, reg_c)
      reg_a = reg_a / (2 ** combo)
    when 1 # bxl
      reg_b = reg_b ^ operand
    when 2 # bst
      combo = get_combo_value(operand, reg_a, reg_b, reg_c)
      reg_b = combo % 8
    when 3 # jnz
      if reg_a != 0
        ip = operand
        next
      end
    when 4 # bxc
      reg_b = reg_b ^ reg_c
    when 5 # out
      combo = get_combo_value(operand, reg_a, reg_b, reg_c)
      output << (combo % 8)
    when 6 # bdv
      combo = get_combo_value(operand, reg_a, reg_b, reg_c)
      reg_b = reg_a / (2 ** combo)
    when 7 # cdv
      combo = get_combo_value(operand, reg_a, reg_b, reg_c)
      reg_c = reg_a / (2 ** combo)
    end
    ip += 2
  end

  output
end


Utils.time {
  YEAR = 2024
  DAY = 17
  LEVEL = 1

  registers, program = Utils.read_blocks('day17-input.txt')
  # 3 registres (pas nécessairement sur 3 bits) : A (0), B (1) et C (2)
  reg_A, reg_B, reg_C = registers.map { |register| register.split(':').pop.strip.to_i }
  program = program[0].split(':').pop.strip.split(',').map(&:to_i)
  
  sum = execute_program(reg_A, reg_B, reg_C, program).join(',')
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.840892902 secondes

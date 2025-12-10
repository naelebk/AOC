#!/usr/bin/env ruby 
# part1.rb
require_relative '../../utils.rb'

def parse_machine(line)
  target = line.match(/\[([.#]+)\]/)[1]
  target_state = target.chars.map { |c| c == '#' ? 1 : 0 }
  buttons_raw = line.scan(/\(([0-9,]+)\)/)
  buttons = buttons_raw.map { |b| b[0].split(',').map(&:to_i) }
  [target_state, buttons]
end

def solve_machine(target_state, buttons)
  n_lights = target_state.size
  n_buttons = buttons.size
  min_presses = Float::INFINITY
  max = 1 << n_buttons
  (0...max).each do |mask|
    state = [0] * n_lights
    presses = 0
    n_buttons.times do |i|
      if mask & (1 << i) != 0
        buttons[i].each { |light| state[light] ^= 1 }
        presses += 1
      end
    end
    min_presses = [min_presses, presses].min if state == target_state
  end  
  min_presses
end

Utils.time {
  YEAR = 2025
  DAY = 10
  LEVEL = 1

  input = Utils.read_lines('day10-input.txt')
  sum = 0

  input.each do |line|
    target_state, buttons = parse_machine(line)
    min = solve_machine(target_state, buttons)
    sum += min
  end

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}

# Execution: 0.676636229 secondes

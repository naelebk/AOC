#!/usr/bin/env ruby 
# part2.rb
require_relative '../../utils.rb'
require 'ruby-cbc'

=begin
def parse_machine(line)
  target = line.match(/\[([.#]+)\]/)[1]
  target_state = target.chars.map { |c| c == '#' ? 1 : 0 }
  buttons_raw = line.scan(/\(([0-9,]+)\)/)
  buttons = buttons_raw.map { |b| b[0].split(',').map(&:to_i) }
  [target_state, buttons]
end

Solution initiale avec BFS, mais pas du tout optimisée : dans les pires cas,
l’exploration prenait plus d’une heure sans résoudre la moindre machine.
Code de la fonction : 

def solve_with_bfs(target, buttons)
  n = target.size
  initial = [0] * n
  return 0 if initial == target
  queue = [[initial, 0]]
  visited = Set.new([initial.join(',')])
  until queue.empty?
    # ====> c'est elle qui explosait
    puts queue.size
    state, presses = queue.shift
    buttons.each do |button|
      new_state = state.dup
      valid = true
      button.each do |i|
        new_state[i] += 1
        if new_state[i] > target[i]
          valid = false
          break
        end
      end
      next unless valid
      state_key = new_state.join(',')
      next if visited.include?(state_key)
      visited.add(state_key)
      return presses + 1 if new_state == target
      queue << [new_state, presses + 1]
    end
  end
  nil
end

À ce stade, il a fallu se rendre à l’évidence : cette approche ne passerait jamais
à l’échelle raisonnable pour le problème posé.
J’ai donc dû changer complètement d’angle et reformuler le problème comme un
système d’équations linéaires à résoudre via un solveur d’optimisation.
Sans la bibliothèque ruby-cbc, ce code serait tout simplement resté bloqué à l’état
de prototype lent et inutilisable.

Sources d’inspiration :
https://github.com/mbido/advent-of-code/blob/main/aoc_2025/src/day_10.py

Bravo à toi Matthieu pour ta solution, elle est brillante franchement
=end

def parse_machine_part2(line)
  jolts = line.match(/\{([0-9,]+)\}/)[1].split(',').map(&:to_i)
  buttons_raw = line.scan(/\(([0-9,]+)\)/)
  buttons = buttons_raw.map { |b| b[0].split(',').map(&:to_i) }
  [jolts, buttons]
end

def solve_with_cbc(target, buttons)
  n = target.size
  k = buttons.size
  model = Cbc::Model.new
  x = model.int_var_array(
    k,
    0..1000,
    names: (0...k).map { |j| "x#{j}" }
  )
  model.minimize(x.reduce(:+))
  n.times do |i|
    expr = nil
    k.times do |j|
      coef = buttons[j].include?(i) ? 1 : 0
      next if coef == 0
      term = coef * x[j]
      expr = expr ? expr + term : term
    end
    if expr.nil?
      model.enforce(0 == target[i])
    else
      model.enforce(expr == target[i])
    end
  end
  problem = model.to_problem
  problem.solve
  if !problem.proven_infeasible?
    values = x.map { |var| problem.value_of(var).to_i }
    return values.sum
  else
    return nil
  end
rescue => e # rescue obligatoire avec CBC
  puts "Erreur CBC: #{e.class}: #{e.message}"
  nil
end

Utils.time {
  YEAR = 2025
  DAY = 10
  LEVEL = 2
  
  input = Utils.read_lines('day10-input.txt')
  sum = 0
  failed = []  
  input.each_with_index do |line, idx|
    target, buttons = parse_machine_part2(line)
    min = solve_with_cbc(target, buttons)
    if min.nil?
      failed << idx + 1
    else
      sum += min
    end
  end
  
  if failed.empty?
    puts sum
    cookie = Utils.get_cookie
    Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
  else
    puts "Machines échouées : #{failed.join(', ')}"
    puts "Somme partielle : #{sum}"
  end
}

# Execution: 0.508977306 secondes
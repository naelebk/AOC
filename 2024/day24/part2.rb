#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

def find_wrong_gates(gates_list)
  wrong = []
  max_z = gates_list.map { |_, _, _, out| out }.select { |out| out[0] == 'z' }.max

  gates_list.each { |a, operation, b, out|
    wrong << out if out[0] == 'z' && operation != "XOR" && out != max_z
    wrong << out if operation == "XOR" && !(a[0] == 'x' || a[0] == 'y' || b[0] == 'x' || b[0] == 'y') && out[0] != 'z'

    if operation == "AND" && a != "x00" && b != "x00"
      gates_list.each { |a2, operation2, b2, out2|
        next unless a2 == out || b2 == out
        wrong << out if operation2 != "OR"
      }
    end
    
    if operation == "XOR"
      gates_list.each { |a2, operation2, b2, out2|
        next unless a2 == out || b2 == out
        wrong << out if operation2 == "OR"
      }
    end
  }
  wrong.uniq
end

Utils.time {
  YEAR = 2024
  DAY = 24
  LEVEL = 2

  gates_values, gates_list = Utils.read_blocks('day24-input.txt')
  gates_values = gates_values.map { |gv| 
  gv.split(':').map(&:strip) 
    }.map { |key, value| [key, value.to_i] }.to_h
  gates_list = gates_list.map { |gl| gl.split("->") }.map { |a,b| a.split(' ').map(&:strip) + [b.strip] }

  wrong = find_wrong_gates(gates_list)
  sum = wrong.sort.join(",")
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.694857003 secondes
# Ne marche pas sur l'exemple de base mais fonctionne sur le vrai...
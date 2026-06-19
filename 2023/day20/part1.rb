#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

Utils.time {
  YEAR = 2023
  DAY = 20
  LEVEL = 1

  modules = {}
  input = Utils.read_lines("day20-input.txt")
  input.each do |line|
    name, out = line.split("->").map(&:strip)
    out = out.split(",").map(&:strip)
    type = name == "broadcaster" ? nil : name[0]
    name = name[1..] if type
    modules[name] = [type, nil, out]
  end
  # init mémoire des conjonctions
  modules.each do |n, (_t, _m, out)|
    out.each do |dst|
      t = modules[dst]&.first
      if t == ?&
        modules[dst][1] ||= {}
        modules[dst][1][n] = :l
      end
    end
  end
  # flip-flops à false
  modules.each { |_n, m| m[1] = false if m[0] == ?% }

  lc = hc = 0
  1000.times do
    queue = [["button", "broadcaster", :l]]
    until queue.empty?
      from, to, sig = queue.shift
      sig == :l ? lc += 1 : hc += 1 # compte à la réception
      type, memory, out = modules[to]
      next if type.nil? && to != "broadcaster" # puits (output, rx, ...)
      out_sig =
        case type
        when nil # broadcaster
          sig
        when ?%
          next if sig == :h
          modules[to][1] = !memory
          modules[to][1] ? :h : :l
        when ?&
          memory[from] = sig
          memory.values.all? { _1 == :h } ? :l : :h
        end
      out.each { queue << [to, _1, out_sig] }
    end
  end

  sum = hc * lc
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.424003075 secondes

#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'
Utils.time {
  YEAR = 2023
  DAY = 20
  LEVEL = 2

  modules = {}
  input = Utils.read_lines("day20-input.txt")
  input.each do |line|
    name, out = line.split("->").map(&:strip)
    out = out.split(",").map(&:strip)
    type = name == "broadcaster" ? nil : name[0]
    name = name[1..] if type
    modules[name] = [type, nil, out]
  end
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
  # --- identification de g (la conjonction qui pointe vers rx) ---
  feeder = modules.find { |_n, (_t, _m, out)| out.include?("rx") }.first
  # --- entrées de g : conjonctions qui pointent vers feeder ---
  watched = modules.select { |_n, (_t, _m, out)| out.include?(feeder) }.keys
  periods = {}
  press = 0
  until watched.all? { |w| periods.key?(w) }
    press += 1
    queue = [["button", "broadcaster", :l]]
    until queue.empty?
      from, to, sig = queue.shift
      # quand une entrée surveillée envoie un :h vers feeder (période notée)
      periods[from] = press if to == feeder && sig == :h && !periods.key?(from)
      type, memory, out = modules[to]
      next if type.nil? && to != "broadcaster"
      out_sig =
        case type
        when nil
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

  sum = periods.values.reduce(1, :lcm)
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.4800483 secondes
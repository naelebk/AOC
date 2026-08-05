#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

def is_correct_rule?(rules, update)
  update.each_with_index do |page, idx|
    (idx + 1...update.size).each do |next_idx|
      next_page = update[next_idx]
      # si une page suivante devait être AVANT la page courante selon les règles, c'est invalide
      return false if rules.include?([next_page, page])
    end
  end
  true
end

def order_rule_correctly(rules, update)
  update.sort do |a, b|
    if rules.include?([a, b])
      -1
    elsif rules.include?([b, a])
      1
    else
      0
    end
  end
end

Utils.time {
  YEAR = 2024
  DAY = 05
  LEVEL = 2

  rules_raw, updates = Utils.read_blocks("day05-input.txt")
  # Set pour gagner en performances (O(1) pour les accès)
  rules = Set.new(rules_raw.map { |line| line.split('|').map(&:to_i) })
  updates.map! { |line| line.split(',').map(&:to_i) }
  
  sum = updates.reject { |update|
    is_correct_rule?(rules, update) 
  }.map { |incorrect| 
    order_rule_correctly(rules, incorrect)
  }.sum { |array|
    array[array.size / 2]
  }

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.668801905 secondes




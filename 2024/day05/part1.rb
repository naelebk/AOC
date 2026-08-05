#!/usr/bin/env ruby
# part1.rb
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

Utils.time {
  YEAR = 2024
  DAY = 05
  LEVEL = 1

  rules_raw, updates = Utils.read_blocks("day05-input.txt")
  rules = Set.new(rules_raw.map { |line| line.split('|').map(&:to_i) })
  updates.map! { |element| element.split(',').map(&:to_i) }
  
  sum = updates.reject { |update|
    !is_correct_rule?(rules, update) 
  }.sum { |correct|
    correct[correct.size / 2]
  }

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.688131406 secondes

#!/usr/bin/env ruby 
# part2.rb
require_relative '../../utils.rb'

def count_arrangements(springs, groups, cache = {})
  state = [springs, groups]
  return cache[state] if cache.key?(state)
  return groups.empty? ? 1 : 0 if springs.empty?
  return springs.include?('#') ? 0 : 1 if groups.empty?
  res = 0
  res += count_arrangements(springs[1..-1], groups, cache) if [".", "?"].include?(springs[0])
  if ["#", "?"].include?(springs[0])
    group_size = groups[0]    
    if group_size <= springs.length &&
       !springs[0...group_size].include?(".") && # pas de '.' au milieu du bloc
       (group_size == springs.length || springs[group_size] != "#") # pas de '#' juste après
      next_springs = springs[(group_size + 1)..-1] || ""
      res += count_arrangements(next_springs, groups[1..-1], cache)
    end
  end
  cache[state] = res
  res
end

Utils.time {
  YEAR = 2023
  DAY = 12
  LEVEL = 2

  sum = Utils.read_csv('day12-input.txt', ' ').sum do |springs, sequence|
    count_arrangements(([springs] * 5).join('?'), sequence.split(',').map(&:to_i) * 5)
  end
  
  puts sum
  
  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 1.005001589 secondes

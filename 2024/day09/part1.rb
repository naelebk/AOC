#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

def file_compacting(file)
  tab = []
  k = 0
  file.each_with_index do |element, i|
    if i % 2 == 0
      element.times { tab << k }
      k += 1
    else
      element.times { tab << '.' }
    end
  end
  
  left = 0
  right = tab.size - 1

  while left < right
    if tab[left] == '.'
      while right > left && tab[right] == '.'
        right -= 1
      end
      tab[left], tab[right] = tab[right], tab[left]
    end
    left += 1
  end

  tab.reject { |element| element == '.' }
end


Utils.time {
  YEAR = 2024
  DAY = 9
  LEVEL = 1

  input = Utils.read_matrix("day09-input.txt")[0].map(&:to_i)
  tab = file_compacting(input)
  sum = 0
  tab.each_with_index { |element, i| sum += element * i }

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.600898164 secondes

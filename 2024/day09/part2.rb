#!/usr/bin/env ruby
# part2.rb
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

  blocks = []
  right = tab.size - 1
  
  while right >= 0
    if tab[right] != '.'
      current = tab[right]
      block_size = 0
      start_block = right
      while right >= 0 && tab[right] == current
        block_size += 1
        right -= 1
      end
      blocks << { start: start_block - block_size + 1, size: block_size, id: current }
    else
      right -= 1
    end
  end

  free_spaces = []
  left = 0
  while left < tab.size
    if tab[left] == '.'
      free_start = left
      free_size = 0
      while left < tab.size && tab[left] == '.'
        free_size += 1
        left += 1
      end
      free_spaces << { start: free_start, size: free_size }
    else
      left += 1
    end
  end

  blocks.each do |block|
    free_spaces.each_with_index do |free, idx|
      break if free[:start] >= block[:start]
      if free[:size] >= block[:size]
        (0...block[:size]).each do |i|
          tab[free[:start] + i] = block[:id]
          tab[block[:start] + i] = '.'
        end
        free[:start] += block[:size]
        free[:size] -= block[:size]
        free_spaces.delete_at(idx) if free[:size] == 0
        break
      end
    end
  end

  tab
end

Utils.time {
  YEAR = 2024
  DAY = 9
  LEVEL = 2

  input = Utils.read_matrix("day09-input.txt")[0].map(&:to_i)
  tab = file_compacting(input)
  sum = 0
  tab.each_with_index { |element, i|
    next if element == '.'
    sum += element * i
  }

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.638445547 secondes

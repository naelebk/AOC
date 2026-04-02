#!/usr/bin/env ruby 
# part2.rb
require_relative '../../utils.rb'

def hash_algorithm(string)
  current = 0
  string.each_byte do |s|
    current += s
    current *= 17
    current %= 256
  end
  current
end

def build_boxes(input)
  boxes = Array.new(256) { [] }
  input.each do |operation|
    if operation.include?('-')
      label = operation.chomp('-')
      box_idx = hash_algorithm(label)
      boxes[box_idx].delete_if { |lens| lens[:label] == label }
    elsif operation.include?('=')
      label, focal_length = operation.split('=')
      box_idx = hash_algorithm(label)
      focal_length = focal_length.to_i      
      existing_lens = boxes[box_idx].find { |lens| lens[:label] == label }
      if existing_lens
        existing_lens[:focal] = focal_length
      else
        boxes[box_idx] << { label: label, focal: focal_length }
      end
    end
  end
  boxes
end

def sum_boxes_power(boxes)
  total_power = 0
  boxes.each_with_index do |box, i|
    box.each_with_index do |lens, j|
      total_power += (i + 1) * (j + 1) * lens[:focal]
    end
  end
  total_power
end


Utils.time {
  YEAR = 2023
  DAY = 15
  LEVEL = 2

  input = Utils.read_lines('day15-input.txt')[0].split(',')
  sum = sum_boxes_power(build_boxes(input))
  
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.794697713 secondes

#!/usr/bin/env ruby 
# part2.rb
require_relative '../../utils.rb'

def string_to_array(line)
  line[1..].map! do |i| i.split(' ').map(&:to_i) end
end

def convert_range(ranges, mapping)
  result = []
  ranges.each do |left, right|
    current = left
    mapping.each do |dest, source, length|
      src_end = source + length - 1
      next if right < source || current > src_end
      if current < source
        result << [current, source - 1]
        current = source
      end
      overlap_end = [right, src_end].min
      new_left  = dest + (current - source)
      new_right = dest + (overlap_end - source)
      result << [new_left, new_right]
      current = overlap_end + 1
      break if current > right
    end
    result << [current, right] if current <= right
  end
  result
end

Utils.time {
  YEAR = 2023
  DAY = 5
  LEVEL = 2

  blocks = Utils.read_blocks('day5-input.txt')
  seeds, seed_to_soil, soil_to_fertilizer, fertilize_to_water, water_to_light, light_to_temperature, temperature_to_humidity, humidity_to_location = blocks
  seeds_numbers = Utils.chunks(
    seeds[0].split(':')[1].strip.split(' ').map(&:to_i),
    2
  ).map! do |left, right|
    [left, left + right - 1]
  end
  
  seed_to_soil_numbers = string_to_array(seed_to_soil).sort_by! { |element| element[1] }
  soil_to_fertilizer_numbers = string_to_array(soil_to_fertilizer).sort_by! { |element| element[1] }
  fertilize_to_water_numbers = string_to_array(fertilize_to_water).sort_by! { |element| element[1] }
  water_to_light_numbers = string_to_array(water_to_light).sort_by! { |element| element[1] }
  light_to_temperature_numbers = string_to_array(light_to_temperature).sort_by! { |element| element[1] }
  temperature_to_humidity_numbers = string_to_array(temperature_to_humidity).sort_by! { |element| element[1] }
  humidity_to_location_numbers = string_to_array(humidity_to_location).sort_by! { |element| element[1] }

  ranges = seeds_numbers
  ranges = convert_range(ranges, seed_to_soil_numbers)
  ranges = convert_range(ranges, soil_to_fertilizer_numbers)
  ranges = convert_range(ranges, fertilize_to_water_numbers)
  ranges = convert_range(ranges, water_to_light_numbers)
  ranges = convert_range(ranges, light_to_temperature_numbers)
  ranges = convert_range(ranges, temperature_to_humidity_numbers)
  ranges = convert_range(ranges, humidity_to_location_numbers)

  sum = ranges.map(&:first).min

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}

# Execution: 1.103847511 secondes

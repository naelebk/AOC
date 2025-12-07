#!/usr/bin/env ruby 
# part1.rb
require_relative '../../utils.rb'

def string_to_array(line)
  line[1..].map! do |i| i.split(' ').map(&:to_i) end
end

def convert_number(num, mapping)
  mapping.each do |dest, source, length|
    if num >= source && num < source + length
      return dest + (num - source)
    end
  end
  num
end

Utils.time {
  YEAR = 2023
  DAY = 5
  LEVEL = 1

  blocks = Utils.read_blocks('day5-input.txt')
  seeds, seed_to_soil, soil_to_fertilizer, fertilize_to_water, water_to_light, light_to_temperature, temperature_to_humidity, humidity_to_location = blocks
  seeds_numbers = seeds[0].split(':')[1].strip.split(' ').map(&:to_i)
  seed_to_soil_numbers = string_to_array(seed_to_soil)
  soil_to_fertilizer_numbers = string_to_array(soil_to_fertilizer)
  fertilize_to_water_numbers = string_to_array(fertilize_to_water)
  water_to_light_numbers = string_to_array(water_to_light)
  light_to_temperature_numbers = string_to_array(light_to_temperature)
  temperature_to_humidity_numbers = string_to_array(temperature_to_humidity)
  humidity_to_location_numbers = string_to_array(humidity_to_location)

  sum = seeds_numbers.map { |seed|
    soil = convert_number(seed, seed_to_soil_numbers)
    fertilizer = convert_number(soil, soil_to_fertilizer_numbers)
    water = convert_number(fertilizer, fertilize_to_water_numbers)
    light = convert_number(water, water_to_light_numbers)
    temperature = convert_number(light, light_to_temperature_numbers)
    humidity = convert_number(temperature, temperature_to_humidity_numbers)
    location = convert_number(humidity, humidity_to_location_numbers)
    location
  }.min

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}

# Execution: 0.647450101 secondes

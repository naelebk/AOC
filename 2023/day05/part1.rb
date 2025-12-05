#!/usr/bin/env ruby 
# part1.rb
require_relative '../../utils.rb'

def string_to_i(line)
  tab = line[1..].map! do |i|
    i.split(' ').map(&:to_i)
  end
  tab
end

Utils.time {
  YEAR = 2023
  DAY = 5
  LEVEL = 1

  blocks = Utils.read_blocks('day5-input.txt')
  sum = 0
  seeds, seed_to_soil, soil_to_fertilizer, fertilize_to_water, water_to_light, light_to_temperature, temperature_to_humidity, humidity_to_location = blocks
  # ... LOOOOL
  seeds_numbers = seeds[0].split(':')[1].strip.split(' ').map(&:to_i)
  seed_to_soil_numbers = string_to_i(seed_to_soil)
  soil_to_fertilizer_numbers = string_to_i(soil_to_fertilizer)
  fertilize_to_water_numbers = string_to_i(fertilize_to_water)
  water_to_light_numbers = string_to_i(water_to_light)
  light_to_temperature_numbers = string_to_i(light_to_temperature)
  temperature_to_humidity_numbers = string_to_i(temperature_to_humidity)
  humidity_to_location_numbers = string_to_i(humidity_to_location)
  # JE TERMINERAI PLUS TARD LOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOL


  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}

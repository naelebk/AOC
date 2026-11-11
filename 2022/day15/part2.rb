#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

ROW_MAX = 4000000
# ROW_MAX = 20

def get_beacons_and_sensors(input)
  sensors = {}
  beacons = Set.new
  input.each do |line|
    x, y, dx, dy = line
    p1 = [x, y]
    p2 = [dx, dy]
    dist = Utils.manhattan(p1, p2)
    sensors[p1] = dist
    beacons << [dx, dy]
  end
  [sensors, beacons]
end

def intervals_on_row(sensors, row)
  intervals = []
  sensors.each do |(sx, sy), dist|
    reste = dist - (sy - row).abs
    next if reste < 0
    intervals << [sx - reste, sx + reste]
  end
  intervals
end

def find_gap(intervals, max)
  cur = 0
  intervals.sort.each do |a, b|
    return cur if a > cur
    cur = b + 1 if b + 1 > cur
    return nil if cur > max
  end
  cur <= max ? cur : nil
end
  

Utils.time {
  YEAR = 2022
  DAY = 15
  LEVEL = 2

  input = Utils.read_lines("day15-input.txt").map { |line| Utils.parse_ints(line) }
  sensors, _ = get_beacons_and_sensors(input)
  sum = nil
  (0..ROW_MAX).each do |row|
    x = find_gap(intervals_on_row(sensors, row), ROW_MAX)
    next if x.nil?
    sum = x * 4000000 + row
    break
  end

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 18.372264886 secondes
# Pas ma version la plus opti...
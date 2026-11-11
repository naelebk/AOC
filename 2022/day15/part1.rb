#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

ROW = 2000000
# ROW = 10

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

def merge_intervals(intervals)
  merged = []
  intervals.sort.each do |a, b|
    if merged.empty? || a > merged.last[1] + 1
      merged << [a, b]
    else
      merged.last[1] = [merged.last[1], b].max
    end
  end
  merged
end
  

Utils.time {
  YEAR = 2022
  DAY = 15
  LEVEL = 1

  input = Utils.read_lines("day15-input.txt").map { |line| Utils.parse_ints(line) }
  sensors, beacons = get_beacons_and_sensors(input)
  merged = merge_intervals(intervals_on_row(sensors, ROW))
  sum = merged.sum { |a, b| b - a + 1 }

  beacons.each do |bx, by|
    next unless by == ROW
    sum -= 1 if merged.any? { |a, b| bx.between?(a, b) }
  end

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.311542107 secondes
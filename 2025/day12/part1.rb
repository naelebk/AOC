#!/usr/bin/env ruby 
# part1.rb
require_relative '../../utils.rb'
require 'timeout'

def parse_input(path)
  lines = Utils.read_lines(path)
  patterns = {}
  puzzles = []
  i = 0
  while i < lines.size
    line = lines[i]    
    if line =~ /^(\d+):$/
      pattern_id = $1.to_i
      grid = []
      i += 1
      while i < lines.size && lines[i] =~ /^[#.]+$/
        grid << lines[i].chars
        i += 1
      end
      coords = []
      grid.each_with_index do |row, y|
        row.each_with_index do |cell, x|
          coords << [y, x] if cell == '#'
        end
      end
      patterns[pattern_id] = coords
    elsif line =~ /^(\d+)x(\d+): (.+)$/
      width, height, nums = $1.to_i, $2.to_i, $3.split.map(&:to_i)
      puzzles << { width: width, height: height, patterns: nums }
      i += 1
    else
      i += 1
    end
  end  
  [patterns, puzzles]
end

def transforms(coords)
  [ # c'est du Utils.neighbors8 mais je dois map sur le tableau donc obliger de faire à la main
    coords,
    coords.map { |y, x| [-x, y] },
    coords.map { |y, x| [-y, -x] },
    coords.map { |y, x| [x, -y] },
    coords.map { |y, x| [y, -x] },
    coords.map { |y, x| [x, y] },
    coords.map { |y, x| [-y, x] },
    coords.map { |y, x| [-x, -y] }
  ].map {
    |c| my, mx = c.map(&:first).min, c.map(&:last).min; c.map { |y, x| [y - my, x - mx] }
  }.uniq
end

def solve(board, gifts, width, height, idx = 0)
  return true if idx >= gifts.size
  transforms(gifts[idx]).any? do |coords|
    (0...height).any? do |y|
      (0...width).any? do |x|
        if coords.all? { |dy, dx| (ny = y + dy) < height && (nx = x + dx) < width && !board[ny * width + nx] }
          coords.each { |dy, dx| board[(y + dy) * width + x + dx] = idx }
          result = solve(board, gifts, width, height, idx + 1)
          coords.each { |dy, dx| board[(y + dy) * width + x + dx] = nil }
          return true if result
        end
      end
    end
  end
  false
end

Utils.time {
  YEAR = 2025
  DAY = 12
  LEVEL = 1
  
  patterns, puzzles = parse_input('day12-input.txt')
  count = 0  
  puzzles.each_with_index do |puzzle, idx|
    width = puzzle[:width]
    height = puzzle[:height]
    counts = puzzle[:patterns]
    gifts = counts.flat_map.with_index { |n, id| [patterns[id]] * n }
    begin # on brut force par timeout
      can_fit = Timeout::timeout(0.1) do
        solve(Array.new(width * height), gifts, width, height)
      end
      count += 1 if can_fit
    rescue Timeout::Error
      puts "Puzzle #{idx + 1} (#{width}x#{height}): TIMEOUT"
    end
  end
  
  puts count
  
  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, count, cookie)
}

# Execution: 113.852552914 secondes
# Le pire c'est que ça marche en moins de 2 minutes PTDRRRRR
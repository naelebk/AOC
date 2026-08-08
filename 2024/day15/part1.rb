#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

LEFT = '<'
RIGHT = '>'
UP = '^'
DOWN = 'v'

DIRECTIONS = {
  LEFT => [0, -1],
  RIGHT => [0, 1],
  UP => [-1, 0],
  DOWN => [1, 0],
}

def get_next_coordinate(move, y, x)
  dy, dx = DIRECTIONS[move]
  [y + dy, x + dx]
end

def can_push_boxes(grid, dy, dx, cy, cx)
  # on regarde s'il y a une boîte à la position (cy, cx)
  return true if grid[cy][cx] == '.'
  return false if grid[cy][cx] == '#'
  next_y, next_x = cy + dy, cx + dx
  can_push_boxes(grid, dy, dx, next_y, next_x)
end

def push_boxes(grid, dy, dx, cy, cx)
  next_y, next_x = cy + dy, cx + dx
  push_boxes(grid, dy, dx, next_y, next_x) if grid[next_y][next_x] == 'O'
  grid[next_y][next_x] = 'O'
end

def simulate_move(grid, move, ry, rx)
  return [ry, rx] unless DIRECTIONS.key?(move)
  dy, dx = DIRECTIONS[move]
  next_y, next_x = ry + dy, rx + dx

  # mur
  return [ry, rx] if grid[next_y][next_x] == '#'

  # rien donc on peut bouger
  if grid[next_y][next_x] == '.'
    grid[next_y][next_x] = '@'
    grid[ry][rx] = '.'
    return [next_y, next_x]
  end

  # boxe, dans ce cas il faut simuler le mouvement pour voir si on peut en pousser ou pas
  # pour que le robot se déplace
  if grid[next_y][next_x] == 'O'
    if can_push_boxes(grid, dy, dx, next_y, next_x)
      push_boxes(grid, dy, dx, next_y, next_x)
      grid[next_y][next_x] = '@'
      grid[ry][rx] = '.'
      return [next_y, next_x]
    end
  end

  [ry, rx]
end

def move_robot(grid, moves)
  current_y, current_x = Utils.find_in_grid('@', grid)
  moves.each { |move| current_y, current_x = simulate_move(grid, move, current_y, current_x) }
  grid
end

Utils.time {
  YEAR = 2024
  DAY = 15
  LEVEL = 1

  grid, moves = Utils.read_blocks("day15-input.txt")
  grid.map! { |row| row.split('') }
  moves = moves.join.split('')

  new_grid = move_robot(grid, moves)
  height, width = Utils.get_size_of_grid(new_grid)
  sum = 0
  new_grid.each_with_index do |row, y|
    row.each_with_index do |element, x|
      sum += 100 * y + x if element == 'O'
    end
  end

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.660716338 secondes
#!/usr/bin/env ruby
# part2.rb
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

def can_push_boxes_horizontal(grid, dx, cy, cx)
  return true if grid[cy][cx] == '.'
  return false if grid[cy][cx] == '#'
  can_push_boxes_horizontal(grid, dx, cy, cx + dx)
end

def push_boxes_horizontal(grid, dx, cy, cx)
  return if grid[cy][cx] == '.'
  push_boxes_horizontal(grid, dx, cy, cx + dx)
  grid[cy][cx + dx] = grid[cy][cx]
end

def get_affected_boxes(grid, dy, dx, cy, cx, visited = Set.new)
  cx -= 1 if grid[cy][cx] == ']'
  return [] if visited.include?([cy, cx])
  visited.add([cy, cx])
  next_y = cy + dy
  affected = [[cy, cx]]
  left_cell = grid[next_y][cx]
  right_cell = grid[next_y][cx + 1]

  if left_cell == ']'
    affected += get_affected_boxes(grid, dy, dx, next_y, cx - 1, visited)
  end

  if left_cell == '['
    affected += get_affected_boxes(grid, dy, dx, next_y, cx, visited)
  end

  if right_cell == ']'
    affected += get_affected_boxes(grid, dy, dx, next_y, cx + 1, visited)
  end

  if right_cell == '['
    affected += get_affected_boxes(grid, dy, dx, next_y, cx + 1, visited)
  end
  affected
end

def can_push_boxes_vertical(grid, dy, cy, cx)
  cx -= 1 if grid[cy][cx] == ']'
  next_y = cy + dy

  return false if grid[next_y][cx] == '#' || grid[next_y][cx + 1] == '#'

  left_cell = grid[next_y][cx]
  right_cell = grid[next_y][cx + 1]

  if left_cell == ']'
    return false unless can_push_boxes_vertical(grid, dy, next_y, cx - 1)
  end

  if left_cell == '['
    return false unless can_push_boxes_vertical(grid, dy, next_y, cx)
  end

  if right_cell == ']' || (right_cell == '[' && left_cell != '[')
    return false unless can_push_boxes_vertical(grid, dy, next_y, cx + 1)
  end

  true
end

def push_boxes_vertical(grid, dy, dx, cy, cx)
  cx -= 1 if grid[cy][cx] == ']'
  affected = get_affected_boxes(grid, dy, dx, cy, cx)
  affected.sort_by! { |y, x| dy > 0 ? -y : y }.each do |y, x|
    next_y = y + dy
    grid[next_y][x] = '['
    grid[next_y][x + 1] = ']'
    grid[y][x] = '.'
    grid[y][x + 1] = '.'
  end
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
  if grid[next_y][next_x] == '[' || grid[next_y][next_x] == ']'
    if dy == 0 # horizontal
      if can_push_boxes_horizontal(grid, dx, next_y, next_x)
        push_boxes_horizontal(grid, dx, next_y, next_x)
        grid[next_y][next_x] = '@'
        grid[ry][rx] = '.'
        return [next_y, next_x]
      end
    elsif dx == 0 # vertical
      if can_push_boxes_vertical(grid, dy, next_y, next_x)
        push_boxes_vertical(grid, dy, dx, next_y, next_x)
        grid[next_y][next_x] = '@'
        grid[ry][rx] = '.'
        return [next_y, next_x]
      end
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
  LEVEL = 2

  grid, moves = Utils.read_blocks("day15-input.txt")
  grid.map! { |row| row.split('') }.map! do |row|
    row.map! { |element|
      element = ['#', '#'] if element == '#'
      element = ['[',']'] if element == 'O'
      element = ['.','.'] if element == '.'
      element = ['@', '.'] if element == '@'
      element
    }.join.split('')
  end
  moves = moves.join.split('')

  new_grid = move_robot(grid, moves)
  height, width = Utils.get_size_of_grid(new_grid)
  sum = 0
  new_grid.each_with_index do |row, y|
    row.each_with_index do |element, x|
      sum += 100 * y + x if element == '['
    end
  end

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.717181328 secondes

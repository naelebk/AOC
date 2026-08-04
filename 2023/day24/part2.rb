#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

# produit vectoriel de 2 vecteurs 3D
def cross(a, b)
  [
    a[1] * b[2] - a[2] * b[1],
    a[2] * b[0] - a[0] * b[2],
    a[0] * b[1] - a[1] * b[0]
  ]
end

def build_equations(h1, h2)
  p1 = h1[0..2]
  v1 = h1[3..5]
  p2 = h2[0..2]
  v2 = h2[3..5]
  dx, dy, dz = [p1[0] - p2[0], p1[1] - p2[1], p1[2] - p2[2]]
  ex, ey, ez = [v1[0] - v2[0], v1[1] - v2[1], v1[2] - v2[2]]
  rx, ry, rz = cross(p1, v1).zip(cross(p2, v2)).map { |a, b| a - b }
  [
    [[0, ez, -ey, 0, -dz, dy], rx],
    [[-ez, 0, ex, dz, 0, -dx], ry],
    [[ey, -ex, 0, -dy, dx, 0], rz]
  ]
end

def solve_linear_system(rows)
  n = rows.size
  matrix = rows.map { |coeffs, rhs| coeffs.map { |c| Rational(c) } + [Rational(rhs)] }
  n.times do |col|
    pivot_row = (col...n).find { |r| matrix[r][col] != 0 }
    raise "NON SOLVABLE !!!" if pivot_row.nil?
    matrix[col], matrix[pivot_row] = matrix[pivot_row], matrix[col]
    pivot = matrix[col][col]
    matrix[col] = matrix[col].map { |v| v / pivot }
    n.times do |row|
      next if row == col
      factor = matrix[row][col]
      next if factor == 0
      matrix[row] = matrix[row].each_with_index.map { |v, i| v - factor * matrix[col][i] }
    end
  end
  matrix.map { |row| row.last }
end

def find_rock(hailstones)
  h0, h1, h2 = hailstones[0], hailstones[1], hailstones[2]
  equations = build_equations(h0, h1) + build_equations(h0, h2)
  solve_linear_system(equations)
end

Utils.time {
  YEAR = 2023
  DAY = 24
  LEVEL = 2

  input = Utils.read_csv('day24-input.txt', '@').map do |left, right|
    left.split(',').map(&:to_i) + right.split(',').map(&:to_i)
  end

  px, py, pz, _vx, _vy, _vz = find_rock(input)
  sum = (px + py + pz).to_i
  
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.831582506 secondes
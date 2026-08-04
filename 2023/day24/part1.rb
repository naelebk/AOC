#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

X_Y_RANGE = (200000000000000..400000000000000)

# calcule les coefficients a, b, c de la droite d'un flocon sous la forme a*x + b*y = c
# a = vy, b = -vx, c = vy*px - vx*py (forme qui évite les divisions par zéro sur les verticales)
def line_equation(hailstone)
  px, py, _pz, vx, vy, _vz = hailstone
  a = vy
  b = -vx
  c = vy * px - vx * py
  [a, b, c]
end

def intersection(a1, b1, c1, a2, b2, c2)
  det = a1 * b2 - a2 * b1
  return nil if det == 0
  x = Rational(c1 * b2 - c2 * b1, det)
  y = Rational(a1 * c2 - a2 * c1, det)
  [x, y]
end

def future?(hailstone, x, y)
  px, py, _pz, vx, vy, _vz = hailstone
  t = vx != 0 ? Rational(x - px, vx) : Rational(y - py, vy)
  t >= 0
end

def get_hailstones_to_collide(hailstones, range)
  count = 0
  Utils.combinations(hailstones, 2).each do |a, b|
    a1, b1, c1 = line_equation(a)
    a2, b2, c2 = line_equation(b)
    point = intersection(a1, b1, c1, a2, b2, c2)
    next if point.nil?
    x, y = point
    next unless future?(a, x, y)
    next unless future?(b, x, y)
    next unless range.cover?(x) && range.cover?(y)
    count += 1
  end
  count
end

Utils.time {
  YEAR = 2023
  DAY = 24
  LEVEL = 1

  input = Utils.read_csv('day24-input.txt', '@').map do |left, right|
    left.split(',').map(&:to_i) + right.split(',').map(&:to_i)
  end

  sum = get_hailstones_to_collide(input, X_Y_RANGE)
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.807856212 secondes
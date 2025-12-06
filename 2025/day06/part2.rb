#!/usr/bin/env ruby 
# part2.rb
require_relative '../../utils.rb'

# Putain j'ai bien galéré sur celui-là ! Le piège c'est qu'il faut lire les nombres
# de DROITE À GAUCHE dans chaque problème, pas de gauche à droite comme d'habitude
# J'ai dû reconstruire tout le parsing caractère par caractère pour bien gérer ça

Utils.time {
  YEAR = 2025
  DAY = 6
  LEVEL = 2

  lines = Utils.read_lines("day6-input.txt")
  sum = 0

  rows = lines.map { |line| line.chars }
  max_width = rows.map(&:length).max
  columns = (0...max_width).map do |col_idx|
    rows.map { |row| row[col_idx] || ' ' }
  end
  problems = []
  current_problem = []
  
  columns.each do |column|
    if column.all? { |c| c == ' ' }
      if !current_problem.empty?
        problems << current_problem
        current_problem = []
      end
    else
      current_problem << column
    end
  end
  problems << current_problem if !current_problem.empty?
  
  problems.each do |problem|
    symbol = problem[0][-1]
    numbers = []
    problem.reverse.each do |column|
      digits = column[0...-1].join.strip
      numbers << digits.to_i if !digits.empty? && digits.match?(/^\d+$/)
    end    
    result = if symbol == '+'
      numbers.sum
    else
      Utils.product(numbers)
    end    
    sum += result
  end
  
  puts sum
  
  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}

# Execution: 0.464816436 secondes
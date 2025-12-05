#!/usr/bin/env ruby 
# part2.rb
require_relative '../../utils.rb'

=begin
Remarque importante : l'approche naïve qui génère tous les nombres
individuellement ne fonctionne pas ici pour plusieurs raisons :

  - mémoire : si un range est 1-10000000, créer 10 millions d'entrées
   dans un tableau/Set consomme énormément de RAM (plusieurs Go)

  - temps : itérer sur des millions de nombres avec .upto et les ajouter
   un par un dans un tableau est extrêmement lent (30+ secondes)

  - doublons : avec la méthode.uniq sur un énorme tableau, Ruby doit
  comparer des millions d'éléments entre eux, ce qui aggrave encore la lenteur

Ma solution (plus efficace) est de fusionner les ranges qui se chevauchent, puis
calculer la taille mathématiquement (finish - start + 1) pour chaque
range fusionnée

Complexité en O(n log n) (au lieu de O(somme_des_ranges) initialement...)
=end

def merge_ranges(ranges)
  return [] if ranges.empty?
  sorted = ranges.sort_by(&:first)
  merged = [sorted.first]
  sorted[1..].each do |start, finish|
    last_start, last_finish = merged.last
    if start <= last_finish + 1
      merged[-1] = [last_start, [last_finish, finish].max]
    else
      merged << [start, finish]
    end
  end  
  merged
end

Utils.time {
  YEAR = 2025
  DAY = 5
  LEVEL = 2
  
  blocks = Utils.read_blocks('day5-input.txt')
  ranges_lines = blocks[0]
  ranges = ranges_lines.map do |line|
    line.split('-').map(&:to_i)
  end
  merged = merge_ranges(ranges)
  sum = merged.sum do |start, finish|
    finish - start + 1
  end
  
  puts sum
  
  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}

# Execution: 0.742287309 secondes
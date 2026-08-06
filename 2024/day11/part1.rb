#!/usr/bin/env ruby
# part1.rb
require_relative '../../utils.rb'

BLINKING_TIMES = 25

'''
Initialement cétait cette fonction :

def blinking_eyes(stones)
  tab = stones
  BLINKING_TIMES.times do |j|
    (tab.size - 1).downto(0) do |i|
      element = tab[i]
      if tab[i] == "0"
        tab[i] = "1"
      elsif element.length % 2 == 0
        demi = element.size / 2
        first_part = element[0...demi]
        second_part = element[demi..-1]
        tab[i] = first_part.to_i.to_s
        tab.insert(i + 1, second_part.to_i.to_s)
      else
        tab[i] = (element.to_i * 2024).to_s
      end
    end
  end
  stones.size
end

Mais celle de la partie2 est bien plus optimisée :
'''
def blinking_eyes(stones)
  frequences = stones.tally
  BLINKING_TIMES.times do
    prochaines_frequences = Hash.new(0)
    frequences.each do |pierre, quantite|
      if pierre == "0"
        prochaines_frequences["1"] += quantite
      elsif pierre.length.even?
        demi = pierre.size / 2
        gauche = pierre[0...demi].to_i.to_s
        droite = pierre[demi..-1].to_i.to_s
        prochaines_frequences[gauche] += quantite
        prochaines_frequences[droite] += quantite
      else
        nouvelle_pierre = (pierre.to_i * 2024).to_s
        prochaines_frequences[nouvelle_pierre] += quantite
      end
    end
    frequences = prochaines_frequences
  end
  frequences.values.sum
end

Utils.time {
  YEAR = 2024
  DAY = 11
  LEVEL = 1

  stones = Utils.read_csv('day11-input.txt', ' ')[0]
  sum = blinking_eyes(stones)

  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.704693407 secondes

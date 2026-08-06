#!/usr/bin/env ruby
# part2.rb
require_relative '../../utils.rb'

BLINKING_TIMES = 75

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
  LEVEL = 2

  stones = Utils.read_csv('day11-input.txt', ' ')[0]
  sum = blinking_eyes(stones)
  
  puts sum

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
# Execution: 0.726646806 secondes

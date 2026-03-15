#!/usr/bin/env ruby 
# part2.rb
require_relative '../../utils.rb'

'''
1 : five of a kind
2 : four of a kind
3 : full house
4 : three of a kind
5 : two pair
6 : one pair
7 : high card
'''

def type_with_length_2(hand)
  return 2 if hand.value?(4) && hand.value?(1) # four of a kind
  return 3 if hand.value?(3) && hand.value?(2) # full house
  0
end

def type_with_length_3(hand)
  return 4 if hand.value?(3) && hand.value?(1) # three of a kind
  return 5 if hand.value?(2) && hand.value?(1) # two pairs
  0
end

def type(hand)
  result = Utils.count_occurrences(hand)
  return 1 if result.size == 1 # five of a kind
  return type_with_length_2(result) if result.size == 2 
  return type_with_length_3(result) if result.size == 3
  return 6 if result.size == 4 # one pair
  return 7 if result.size == 5 # high card
  0
end

def advantage_hand(hand)
  occurrences = Utils.count_occurrences(hand)
  nb_j = occurrences.delete("J") || 0
  return hand if nb_j == 0
  return ["A"] * 5 if occurrences.empty? # cas JJJJJ
  best_card = occurrences.max_by { |_, v| v }[0]
  occurrences[best_card] += nb_j
  Utils.untally(occurrences)
end


'''
  T => 10
  J => 11
  Q => 12
  K => 13
  A => 14
'''

correspondance = {
  'T' => 10,
  #'J' => 11,
  'J' => 1, # il devient plus faible que 2
  'Q' => 12,
  'K' => 13,
  'A' => 14
};

def card_value(card, correspondance)
  card.match?(/\d/) ? card.to_i : correspondance[card]
end

def sort_total(table, correspondance)
  table.sort_by do |entry|
    hand_values = entry[:hand].map { |card| card_value(card, correspondance) }
    [entry[:type], *hand_values.map { |v| -v }]
  end.reverse
end

Utils.time {
  YEAR = 2023
  DAY = 7
  LEVEL = 2

  input = Utils.read_csv('day7-input.txt', ' ')
  total = []
  input.each do |hand, bid|
    hand_arr = hand.split('')
    best_hand = advantage_hand(hand_arr)
    type = type(best_hand)
    total << { type: type, hand: hand_arr, bid: bid }
  end

  sorted_total = sort_total(total, correspondance)
  i = 1
  sum = 0
  sorted_total.each do |element|
    sum += i * element[:bid].to_i
    i += 1
  end
  puts sum
  
  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}

# Execution: 0.598202647 secondes

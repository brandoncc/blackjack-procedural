# inititialize player's name
@player_name = ''

# initialize player's scorecard
@score_card = { wins: 0, losses: 0, pushes: 0 }

# initialize deck
@deck = []

def build_deck(deck_count)
  deck_count.times do
    ['Ace', '2', '3', '4', '5', '6', '7', '8',
     '9', '10', 'Jack', 'Queen', 'King'].each do |value|
      ['Clubs', 'Diamonds', 'Hearts', 'Spades'].each do |suit|
        @deck << { suit: suit, value: value }
      end
    end
  end
end

build_deck(5)

# initialize discard pile
@discard_pile = []

# shuffle deck
def shuffle_deck
  @deck << @discard_pile.pop while !@discard_pile.size.zero?

  @deck.shuffle!
end

def say(msg)
  puts "#{msg}"
end

def say_with_hashrocket(msg)
  puts "=> #{msg}"
end

while @player_name =~ /^\s*$/
  # greet player
  say_with_hashrocket('Hello, what is your name?')
  # save player's name
  @player_name = gets.chomp
end

# Ask if player knows rules. If not, show them.
say_with_hashrocket('Do you know how to play blackjack?  If not, I can teach you!')

def show_rules
  say('')
  say_with_hashrocket('Here is a quick overview:')
  say('')
  say('Objective: Accumulate as as close to 21 points as possble, without')
  say('           going over.')
  say('')
  say('How this is achieved:')
  say('  1. You and the dealer are each dealt two cards.')
  say('  2. You are shown your cards.')
  say('  3. You can choose to "stay" or "hit" (receive another card).')
  say('  4. You are repeatedly given this choice, until one of the following is')
  say('     true:')
  say('       a: You choose to stay')
  say('       b: You have 21 points')
  say('       c: You go over 21 points, or "bust"')
  say('')
  say('Scoring:')
  say('  Cards are scored as follows:')
  say('    Ace: 1 or 11 points.  If 11 points makes you bust, the Ace reverts')
  say('         to 1 point')
  say('    2-10: scored as face value')
  say('    Face cards (J, Q, K): 10 points each')
  say('')
  say('Tip: If you have an Ace in your hand which is being calculated as 11')
  say('     points, and you are not sure whether you should hit or not, hit!')
  say('Press any key to continue')

  # after showing rules, wait for input to continue
  gets
end

# start a game

# play_game
#   initialize player's hand
#   initialize dealer's hand
#   deal cards
#   show cards to player
#   ask hit/stay until stay, 21 or bust
#   hit dealer until points are > 17 (unless player hit 21), show cards in
#     between
#   compare scores to figure out a win/loss/push for player
#   show player game result
#   update player's scorecard
#   discard cards
#   Ask if player would like to play again. If not, show scorecard and exit.

# deal_cards
#   deal two cards each to two users
#   return the dealt cards for both users

# show_cards(name, hand)
#   display message containing the cards in hand and who they belong to

# hit(hand)
#   If deck is empty, shuffle discard pile and return the cards to the deck.
#   Deal a card to receiving_player from the deck. (receiving_player << deck.pop)
#   return updated hand (unless it is mutated automatically, need to test this)

# calculate_score(hand)
#   initialize score var
#   initialize non-ace items array
#   initialize ace array
#   calculate score for non-ace array
#   If any items are in the ace array, calculate them in based on whether they
#     need to be 11 points or 1 point. 11 points is preferred, unless it will
#     cause a bust, in which case, calculate it as 1 point.
#   return score
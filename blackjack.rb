require 'pry'

# inititialize player's name
@player_name = ''

# initialize player's scorecard
@score_card = { wins: 0, losses: 0, pushes: 0 }

# initialize deck
@deck = []

# initialize discard pile
@discard_pile = []

# needed methods

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

# shuffle deck
def shuffle_deck
  @deck << @discard_pile.pop while !@discard_pile.size.zero?

  15.times do
    @deck.shuffle!
  end
end

def say(msg)
  puts "#{msg}"
end

def say_with_hashrocket(msg)
  puts "=> #{msg}"
end

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
  say('')
  say('Press any key to continue')

  # after showing rules, wait for input to continue
  gets
end

# deal_cards
def deal_cards(player, dealer)
  # deal two cards each to two users
  2.times do
    shuffle_if_necessary
    player << @deck.shift

    shuffle_if_necessary
    dealer << @deck.shift
  end
end

def shuffle_if_necessary
  if @deck.size.zero?
    shuffle_deck
  end
end

# show_cards(name, hand)
#   display message containing the cards in hand and who they belong to
def show_cards(hand)
  hand.each { |card| say("#{card[:value]} of #{card[:suit]}") }
  say("Current score:  #{calculate_score(*hand)}")
end

# show only player's cards
def show_player_cards(hand)
  # show cards to player
  say_with_hashrocket('Here are your cards: ')
  show_cards(hand)
end

# hit(hand)
def hit(hand)
  #   If deck is empty, shuffle discard pile and return the cards to the deck.
  shuffle_if_necessary

  #   Deal a card to receiving_player from the deck. (receiving_player << deck.pop)
  hand << @deck.shift

  #   return updated hand (unless it is mutated automatically, need to test this)
end

def display_scores(player, dealer)
  say("Your score: #{player}")
  say("Dealer score: #{dealer}")
end

def display_stats
  say_with_hashrocket("Your stats: #{@score_card[:wins]} wins, #{@score_card[:losses]} losses, #{@score_card[:pushes]} pushes")
end

def discard_cards(*hands)
  hands.each do |hand|
    while !hand.size.zero?
      @discard_pile << hand.pop
    end
  end
end

# calculate_score(*hand)
def calculate_score(*cards)
  number_cards = ['2', '3', '4', '5', '6', '7', '8', '9', '10']
  face_cards = ['Jack', 'Queen', 'King']

  # initialize score var
  score = 0
  aces_count = 0

  cards.each do |card|
    if number_cards.include?(card[:value])
      score += card[:value].to_i
    elsif face_cards.include?(card[:value])
      score += 10
    else
      aces_count += 1
    end
  end

  # If any items are in the ace array, calculate them in based on whether they
  #   need to be 11 points or 1 point. 11 points is preferred, unless it will
  #   cause a bust, in which case, calculate it as 1 point.
  aces_count.times do
    if (score + 11) > 21
      score += 1
    else
      score += 11
    end
  end

  # return score
  score
end

# play_game
def play_game
    while true
    # initialize player's hand
    player_hand = []
    player_is_busted = false
    player_hit_21 = false
    player_score = 0

    # initialize dealer's hand
    dealer_hand = []
    dealer_is_busted = false
    dealer_score = 0

    # deal cards
    deal_cards(player_hand, dealer_hand)

    # will be used for the main game loop
    # keep_playing = true

    # show cards to player
    show_player_cards(player_hand)

    while true
      say('')
      # ask hit/stay until stay, 21 or bust
      say_with_hashrocket('Would you like to hit (h) or stay (s)?')

      case gets.chomp.downcase
      when 'h', 'hit'
        hit(player_hand)

        # show updated cards to player
        say_with_hashrocket('Here are your cards: ')
        show_player_cards(player_hand)

        player_score = calculate_score(*player_hand)

        # if bust, break and alert
        if player_score > 21
          say_with_hashrocket('Oh no!  You busted!')
          player_is_busted = true
          break
        elsif player_score == 21
          say_with_hashrocket('You hit 21, you win!!!!!')
          player_hit_21 = true
          break
        end
      when 's', 'stay'
        break
      else
        say_with_hashrocket('Sorry, please enter one of the following: h, hit, s or stay')
      end
    end

    # only let dealer play if player did not bust
    if !player_is_busted && !player_hit_21
      #   hit dealer until points are > 17 (unless player hit 21), show cards in
      #     between
      while true
        dealer_score = calculate_score(*dealer_hand)

        if dealer_score < 17
          hit(dealer_hand)
        else
          if dealer_score > 21
            dealer_is_busted = true
            say_with_hashrocket('Good news!  The dealer busted, you win!')
          end
          break
        end
      end

      say_with_hashrocket("Here are the dealer's final cards:")
      show_cards(dealer_hand)
    end

    # calculate scores one last time for use in messages
    player_score = calculate_score(*player_hand)
    dealer_score = calculate_score(*dealer_hand)

    # compare scores to figure out a win/loss/push for player
    # update player's scorecard
    if player_is_busted
      @score_card[:losses] += 1
    elsif dealer_is_busted || player_hit_21
      @score_card[:wins] += 1
    else
      say('')
      case player_score <=> dealer_score
      when 1
        say_with_hashrocket('You won!')
        @score_card[:wins] += 1
      when -1
        say_with_hashrocket('You lost, bummer!')
        @score_card[:losses] += 1
      else
        say_with_hashrocket('This hand was a push, that is better than a loss!')
        @score_card[:pushes] += 1
      end
      say('')
    end

    #   show player game result
    display_scores(player_score, dealer_score)
    say('')
    display_stats

    #   discard cards
    discard_cards(player_hand, dealer_hand)

    # Ask if player would like to play again. If not, show scorecard and exit.
    while true
      say('')
      say_with_hashrocket('Would you like to play again?')

      case gets.chomp.downcase
      when 'y', 'yes'
        say("Ok, let's play again!")
        break
      when 'n', 'no'
        say("Let's play again soon!")
        return
      else
        say('Sorry, Please enter one of the following: y, yes, n or no')
      end
    end
  end
end

# Initialize deck and gather player intel.
build_deck(5)

shuffle_deck

while @player_name =~ /^\s*$/
  # greet player
  say_with_hashrocket('Hello, what is your name?')
  # save player's name
  @player_name = gets.chomp
end

say("Hello, #{@player_name}")

while true
  # Ask if player knows rules. If not, show them.
  say_with_hashrocket('Do you know how to play blackjack?  If not, I can teach you!')
  case gets.chomp.downcase
  when 'y', 'yes'
    say('Great, lets get started!')
    break
  when 'n', 'no'
    show_rules
    break
  end
end

# start a game
play_game
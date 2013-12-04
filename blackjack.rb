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
  puts <<-RULES.gsub(/^\s*\|/, '')
    |
    |=> Here is a quick overview:
    |
    |Objective: Accumulate as as close to 21 points as possble, without
    |           going over.
    |
    |How this is achieved:
    |  1. You and the dealer are each dealt two cards.
    |  2. You are shown your cards.
    |  3. You can choose to "stay" or "hit" (receive another card).
    |  4. You are repeatedly given this choice, until one of the following is
    |     true:
    |       a: You choose to stay
    |       b: You have 21 points
    |       c: You go over 21 points, or "bust"
    |
    |Scoring:
    |  Cards are scored as follows:
    |    Ace: 1 or 11 points.  If 11 points makes you bust, the Ace reverts
    |         to 1 point
    |    2-10: scored as face value
    |    Face cards (J, Q, K): 10 points each
    |
    |Tip: If you have an Ace in your hand which is being calculated as 11
    |     points, and you are not sure whether you should hit or not, hit!
    |
    |Press any key to continue
  RULES

  # after showing rules, wait for input to continue
  gets
end

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

def show_cards(hand)
  hand.each { |card| say("#{card[:value]} of #{card[:suit]}") }
  say("Current score:  #{calculate_score(*hand)}")
end

# show only player's cards
def show_player_cards(hand)
  say_with_hashrocket('Here are your cards: ')
  show_cards(hand)
end

def hit(hand)
  shuffle_if_necessary
  hand << @deck.shift
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

def calculate_score(*cards)
  number_cards = ['2', '3', '4', '5', '6', '7', '8', '9', '10']
  face_cards = ['Jack', 'Queen', 'King']

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

  score
end

def play_again?
  while true
      say('')
      say_with_hashrocket('Would you like to play again?')

      case gets.chomp.downcase
      when 'y', 'yes'
        say("Ok, let's play again!")
        return true
      when 'n', 'no'
        say("Let's play again soon, #{@player_name}!")
        return false
      else
        say('Sorry, Please enter one of the following: y, yes, n or no')
      end
    end
end

def display_game_result(last_game)
  display_scores(last_game[:player_score], last_game[:dealer_score])
  say('')
  display_stats
end

def compute_winner(game)
  # compare scores to figure out a win/loss/push for player
  # update player's scorecard
  if game[:player_is_busted]
    @score_card[:losses] += 1
  elsif game[:dealer_is_busted] || game[:player_hit_21]
    @score_card[:wins] += 1
  else
    say('')
    case game[:player_score] <=> game[:dealer_score]
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
end

def play_game
  while true
    # initialize stats for new game
    current_game= { player_hand: [], player_is_busted: false,
                    player_hit_21: false, player_score: 0,
                    dealer_hand: [], dealer_is_busted: false,
                    dealer_score: 0 }

    deal_cards(current_game[:player_hand], current_game[:dealer_hand])

    show_player_cards(current_game[:player_hand])

    while true
      say('')
      say_with_hashrocket('Would you like to hit (h) or stay (s)?')

      case gets.chomp.downcase
      when 'h', 'hit'
        hit(current_game[:player_hand])

        show_player_cards(current_game[:player_hand])

        current_game[:player_score] = calculate_score(*current_game[:player_hand])

        # if bust or 21, break and alert
        if current_game[:player_score] > 21
          say_with_hashrocket('Oh no!  You busted!')
          current_game[:player_is_busted] = true
          break
        elsif current_game[:player_score] == 21
          say_with_hashrocket('You hit 21, you win!!!!!')
          current_game[:player_hit_21] = true
          break
        end
      when 's', 'stay'
        break
      else
        say_with_hashrocket('Sorry, please enter one of the following: h, hit, s or stay')
      end
    end

    # only let dealer play if player did not bust
    if !current_game[:player_is_busted] && !current_game[:player_hit_21]
      while true
        current_game[:dealer_score] = calculate_score(*current_game[:dealer_hand])

        if current_game[:dealer_score] < 17
          hit(current_game[:dealer_hand])
        else
          if current_game[:dealer_score] > 21
            current_game[:dealer_is_busted] = true
            say_with_hashrocket('Good news!  The dealer busted, you win!')
          end
          break
        end
      end

      say_with_hashrocket("Here are the dealer's final cards:")
      show_cards(current_game[:dealer_hand])
    end

    # calculate scores one last time for use in messages
    current_game[:player_score] = calculate_score(*current_game[:player_hand])
    current_game[:dealer_score] = calculate_score(*current_game[:dealer_hand])

    compute_winner(current_game)

    display_game_result(current_game)

    discard_cards(current_game[:player_hand], current_game[:dealer_hand])

    break if not play_again?
  end
end

# Initialize deck and gather player intel.
build_deck(5)

shuffle_deck

while @player_name =~ /^\s*$/
  say_with_hashrocket('Hello, what is your name?')
  @player_name = gets.chomp
end

say("Hello, #{@player_name}")

while true
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

play_game
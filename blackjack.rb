# inititialize player's name
# initialize player's scorecard
# initialize deck
# initialize discard pile
# shuffle deck

# greet player
# save player's name
# Ask if player knows rules. If not, show them.
# after showing rules, wait for input to continue
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
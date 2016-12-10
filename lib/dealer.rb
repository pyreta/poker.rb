require_relative './hand.rb'

class Dealer

  attr_reader :board

  def initialize(players, board)
    @players = players
    @deck = Deck.new
    @board = board
  end

  def deal_one_hand
    Hand.new([@deck.take_card, @deck.take_card], @board)
  end

  def deal
    @players.each do |player|
      player.set_hand(deal_one_hand)
    end
  end

  def new_deck
    @deck = Deck.new
  end

  def flop
    @board.add_flop(@deck.take_card, @deck.take_card, @deck.take_card)
  end

  def turn
    @board.add_turn(@deck.take_card)
  end

  def river
    @board.add_river(@deck.take_card)
  end
end

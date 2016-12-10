require_relative './card.rb'

class Board
  attr_reader :flop, :turn, :river, :street

  def initialize
    @flop = []
    @turn = nil
    @river = nil
    @street = :preflop
  end

  def all
    cards = [*@flop]
    cards.push(@turn) if @turn
    cards.push(@river) if @river
    cards
  end

  def add_flop(card1, card2, card3)
    @flop = [card1, card2, card3]
    @street = :flop
  end

  def clear
    @flop = []
    @turn = nil
    @river = nil
    @street = :preflop
  end

  def add_turn(card)
    @turn = card
    @street = :turn
  end

  def add_river(card)
    @river = card
    @street = :river
  end

  def empty_flop
    flop = []
    3.times { flop.push(Card.down_card) }
    flop.join(" ")
  end

  def flop_string
    return empty_flop if @flop.empty?
    @flop.join(" ")
  end

  def turn_string
    @turn ? @turn : Card.down_card
  end

  def river_string
    @river ? @river : Card.down_card
  end

  def to_s
    [flop_string, turn_string, river_string].join("  ")
  end

end

require './card.rb'

class Board
  def initialize
    @flop = []
    @turn = nil
    @river = nil
  end

  def all
    cards = [*@flop]
    cards.push(@turn) if @turn
    cards.push(@river) if @river
    cards
  end

  def add_flop(card1, card2, card3)
    @flop = [card1, card2, card3]
  end

  def clear
    @flop = []
    @turn = nil
    @river = nil
  end

  def add_turn(card)
    @turn = card
  end

  def add_river(card)
    @river = card
  end

  def empty_flop
    flop = []
    3.times { flop.push(Card.down_card) }
    flop.join(" ")
  end

  def flop
    return empty_flop if @flop.empty?
    @flop.join(" ")
  end

  def turn
    @turn ? @turn : Card.down_card
  end

  def river
    @river ? @river : Card.down_card
  end

  def to_s
    [flop, turn, river].join("  ")
  end

end

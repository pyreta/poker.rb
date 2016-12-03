require 'colorize'

class Suit
  SUITS = {
    spades: "♠",
    clubs: "♣",
    diamonds: "♦",
    hearts: "♥",
  }

  def self.suits
    SUITS
  end

  def initialize(suit)
    @suit = suit
  end

  def symbol
    self.class.suits[@suit]
  end

  def suit
    @suit
  end 

  def to_s
    symbol.colorize(color).on_white.bold
  end

  def color
    return :black if [:spades, :clubs].include?(@suit)
    :red
  end
end

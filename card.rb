require 'colorize'
require './suit.rb'


class Card

  CARD_VALUES = {
    :two   => "2",
    :three => "3",
    :four  => "4",
    :five  => "5",
    :six   => "6",
    :seven => "7",
    :eight => "8",
    :nine  => "9",
    :ten   => "10",
    :jack  => "J",
    :queen => "Q",
    :king  => "K",
    :ace   => "A"
  }

  def self.card_values
    CARD_VALUES
  end

  def self.down_card
    "[]".colorize(:blue).on_white.bold
  end

  def initialize(value, suit)
    @value = value
    @suit = Suit.new(suit)
  end

  def value
    @value
  end

  def value_string
    self.class.card_values[@value].colorize(@suit.color).on_white.bold
  end

  def to_s
    value_string + suit_string
  end

  def straight_values
    low_straight = [:five, :four, :three, :two, :ace]
    return low_straight if self.rank < 4
    values = []
    self.rank.downto(self.rank-4) do |idx|
      values.push(self.class.card_values.keys[idx])
    end
    values
  end

  def suit_string
    @suit.to_s
  end

  def suit
    @suit.suit
  end

  def suit_class
    @suit
  end

  def rank
    self.class.card_values.keys.index(@value)
  end

  def <=>(other_card)
    self.rank <=> other_card.rank
  end
end

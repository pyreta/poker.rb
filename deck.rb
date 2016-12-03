require './card.rb'
require './suit.rb'

class Deck
  def initialize
    @cards = []
    create_deck
  end

  def create_deck
    Card.card_values.keys.each do |value|
      Suit.suits.keys.each do |suit|
        @cards.push(Card.new(value, suit))
      end
    end
    @cards.shuffle!
  end

  def cards
    @cards
  end

  def to_s
    @cards.join(" ")
  end

  def take_card
    @cards.pop
  end
end

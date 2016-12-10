require "rspec"
require "deck"

deck = Deck.new

describe Card do
  describe '#initialize' do
    it 'initializes with a full deck' do
      expect(deck.cards.length).to be(52)
    end

    it 'initializes with a shuffled deck' do
      expect(deck.to_s).to eq(deck.to_s)
      expect(deck.to_s).to_not equal(deck.to_s)
      expect(deck.to_s).to_not eq(Deck.new.to_s)
    end
  end

  describe '#take_card' do
    it 'removes a card from the deck and returns it' do
      expect(deck.take_card).to be_a(Card)
      expect(deck.cards.length).to be(51)
    end
  end

end

require "rspec"
require "card"

describe Card do
  describe '#initialize' do
    card = Card.new(:ace, :clubs)
    it 'returns the cards a value' do
      expect(card.value).to eq(:ace)
    end
    it 'returns the cards a suit' do
      expect(card.suit).to eq(:clubs)
    end
  end

  describe '#rank' do
    card = Card.new(:ace, :clubs)
    card2 = Card.new(:ten, :clubs)
    it 'has a rank' do
      expect(card.rank).to be_a(Integer)
    end
    it 'ranks according to value' do
      expect(card.rank > card2.rank).to be(true)
    end
  end

  describe '#straight_values' do
    context 'card is a 5 or greater' do
      card = Card.new(:ace, :clubs)
      card2 = Card.new(:nine, :hearts)
      it 'returns 5 card values in order with card value at the top' do
        expect(card.straight_values).to eq([:ace, :king, :queen, :jack, :ten])
        expect(card2.straight_values).to eq([:nine, :eight, :seven, :six, :five])
      end
    end
    context 'card is less than 5' do
      card = Card.new(:four, :clubs)
      card2 = Card.new(:two, :diamonds)
      it 'returns a 5 high straight' do
        expect(card.straight_values).to eq([:five, :four, :three, :two, :ace])
        expect(card2.straight_values).to eq([:five, :four, :three, :two, :ace])
      end
    end
  end

  describe 'comparisons' do
    card = Card.new(:four, :clubs)
    card2 = Card.new(:two, :diamonds)
    card3 = Card.new(:four, :hearts)

    it 'compares two cards' do
     expect(card <=> card2).to eq(1)
     expect(card <=> card3).to eq(0)
     expect(card2 <=> card3).to eq(-1)
   end

    it 'compares with >, < and ==' do
     expect(card > card2).to be(true)
     expect(card == card3).to be(true)
     expect(card2 > card3).to be(false)
   end
 end
end

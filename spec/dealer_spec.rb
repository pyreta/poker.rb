require "rspec"
require "dealer"
require "board"
require "player"

toby = Player.new(100, "Toby")
luka = Player.new(100, "Luka")
board = Board.new
dealer = Dealer.new([toby, luka], board)

describe Dealer do
    it 'has a board' do
      expect(board).to equal(dealer.board)
    end

    it 'has players' do
      expect(dealer.players.include?(luka)).to be(true)
    end

    it 'has a deck' do
      expect(dealer.deck.cards.length).to be(52)
    end

    it 'deals cards from deck to players' do
      dealer.deal
      expect(dealer.deck.cards.length).to be(48)
      expect(toby.hand.cards.length).to eq(2)
      expect(luka.hand.cards.length).to eq(2)
    end

    it 'deals cards from deck to board' do
      dealer.flop
      expect(dealer.deck.cards.length).to be(45)
      expect(toby.hand.cards.length).to eq(5)
      expect(luka.hand.cards.length).to eq(5)
    end

    it 'can replace the deck' do
      expect(dealer.deck.cards.length).to be(45)
      dealer.new_deck
      expect(dealer.deck.cards.length).to be(52)
    end
end

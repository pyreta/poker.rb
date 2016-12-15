require "rspec"
require "dealer"
require "board"
require "pot"
require "player"
require "card"

board = Board.new
pot = Pot.new
toby = Player.new("Toby")
luka = Player.new("Luka")
tobys_hand = Hand.new([Card.new(:five, :diamonds),
  Card.new(:nine, :hearts)], board)
lukas_hand = Hand.new([Card.new(:six, :diamonds),
  Card.new(:ten, :hearts)], board)
ac = Card.new(:ace, :clubs)
tc = Card.new(:two, :clubs)
fc = Card.new(:four, :clubs)
# dealer = Dealer.new([toby, luka], board)

describe Player do
    it 'has a default name' do
      expect(Player.new().name).to eq('player1')
      expect(Player.new().name).to eq('player2')
    end

    it 'takes an optional name' do
      expect(Player.new('Tom').name).to eq('Tom')
    end

    it 'defaults to no money' do
      expect(Player.new().money).to eq(0)
    end

    it 'takes an optional starting amount' do
      expect(Player.new(300).money).to eq(300)
    end

    it 'accepts a pot' do
      toby.set_pot(pot)
      luka.set_pot(pot)

      toby.pot.add(765)
      expect(luka.pot.money).to be(765)
    end

    it 'accepts a hand' do
      toby.set_hand(tobys_hand)
      luka.set_hand(lukas_hand)

      expect(toby.hand).to equal(tobys_hand)
      expect(luka.hand).to equal(lukas_hand)
      expect(luka.hand.board).to equal(board)
    end
end

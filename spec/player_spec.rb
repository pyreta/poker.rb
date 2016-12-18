require "rspec"
require "dealer"
require "board"
require "pot"
require "player"
require "card"

board = Board.new
pot = Pot.new
toby = Player.new(name: "Toby")
luka = Player.new(name: "Luka", money: 300)
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
      expect(Player.new(name: 'Tom').name).to eq('Tom')
    end

    it 'defaults to no money' do
      expect(Player.new().money).to eq(0)
    end

    it 'takes an optional starting amount' do
      expect(Player.new(money: 300).money).to eq(300)
    end

    it 'accepts a pot' do
      toby.set_pot(pot)
      luka.set_pot(pot)

      toby.pot.add(765)
      expect(luka.pot.money).to be(765)
    end

    it 'puts money in from pot' do
      expect(pot.money).to eq(765)
      expect(luka.money).to eq(300)

      luka.put_money_in_pot(100)

      expect(pot.money).to eq(865)
      expect(luka.money).to eq(200)
    end

    it 'takes money from from pot' do
      expect(pot.money).to eq(865)
      expect(luka.money).to eq(200)

      luka.take_money_from_pot(100)

      expect(pot.money).to eq(765)
      expect(luka.money).to eq(300)
    end

    it 'accepts a hand' do
      toby.set_hand(tobys_hand)
      luka.set_hand(lukas_hand)

      expect(toby.hand).to equal(tobys_hand)
      expect(luka.hand).to equal(lukas_hand)
      expect(luka.hand.board).to equal(board)
    end

    describe 'betting' do
      it 'can fold' do
        expect(toby.folded?).to be(false)
        toby.bet('f')
        expect(toby.folded?).to be(true)
      end

      it 'can bet' do
        luka.bet('200')
        expect(pot.money).to be(965)
        expect(luka.money).to be(100)
      end

      it 'cant bet more than its got' do
        luka.bet('200')
        expect(pot.money).to be(1065)
        expect(luka.money).to be(0)

        luka.bet('500')
        expect(pot.money).to be(1065)
        expect(luka.money).to be(0)
      end

    end
end

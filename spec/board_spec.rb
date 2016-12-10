require "rspec"
require "board"
require "card"

board = Board.new

describe Card do
  describe '#initialize' do
    it 'initializes with an empty flop' do
      expect(board.flop).to be_empty
    end
    it 'initializes no turn' do
      expect(board.turn).to be_nil
    end
    it 'initializes no river' do
      expect(board.river).to be_nil
    end
    it 'initializes at preflop' do
      expect(board.street).to eq(:preflop)
    end
  end

  describe '#add_flop' do
    cards = [Card.new(:ace, :clubs),Card.new(:ace, :diamonds),
      Card.new(:ace, :hearts),]
    it 'can receive a flop' do
      board.add_flop(*cards)
      expect(board.flop.length).to eq(3)
      expect(board.all.length).to eq(3)
      expect(board.flop[0]).to be_a(Card)
    end
    it 'updates the street' do
      expect(board.street).to eq(:flop)
    end
  end

  describe '#add_turn' do
    it 'can receive a turn' do
      board.add_turn(Card.new(:ten, :clubs))
      expect(board.turn).to be_a(Card)
      expect(board.all.length).to eq(4)
    end
    it 'updates the street' do
      expect(board.street).to eq(:turn)
    end
  end

  describe '#add_river' do
    it 'can receive a river' do
      board.add_river(Card.new(:nine, :clubs))
      expect(board.river).to be_a(Card)
      expect(board.all.length).to eq(5)
    end
    it 'updates the street' do
      expect(board.street).to eq(:river)
    end
  end

  describe '#clear' do
    it 'clears all cards' do
      board.clear
      expect(board.flop).to be_empty
      expect(board.turn).to be_nil
      expect(board.river).to be_nil
      expect(board.all.length).to eq(0)
    end
    it 'resets the street' do
      expect(board.street).to eq(:preflop)
    end
  end

end

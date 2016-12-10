require "rspec"
require "card"
require "hand"
require "board"

card1 = Card.new(:ten, :spades)
card2 = Card.new(:two, :clubs)
card3 = Card.new(:ace, :hearts)
card4 = Card.new(:ten, :clubs)
card5 = Card.new(:king, :hearts)
card6 = Card.new(:king, :clubs)
board = Board.new
hand = Hand.new([card1, card2], board)

describe Hand do
  it 'has two cards to start out' do
    expect(hand.cards.length).to be(2)
    expect(hand.cards[0]).to be_a(Card)
  end

  it 'has an initial rank' do
    expect(hand.starting_rank).to be_an(Integer)
  end

  it 'does computes the best five cards before the flop' do
    expect(hand.best_five).to be_nil
    expect(hand.type).to be_nil
  end

  it 'includes cards revealed on the board' do
    board.add_flop(card3, card4, card5)
    expect(hand.cards.length).to be(5)
  end

  it 'sorts cards highest to lowest' do
    expect(hand.cards[-1].value).to be(:two)
    expect(hand.cards[-2].value).to be(:ten)
    expect(hand.cards[0].value).to be(:ace)
  end

  it 'computes the best five cards after the flop' do
    expect(hand.best_five.length).to be(5)
    expect(hand.type).to eq(:pair)
  end

  it 'computes the best five cards after the turn' do
    board.add_turn(Card.new(:ace, :spades))
    expect(hand.best_five.length).to be(5)
    expect(hand.type).to eq(:two_pair)
  end

  it 'computes the best five cards after the river' do
    river_card = Card.new(:ace, :diamonds)
    board.add_river(river_card)
    expect(hand.best_five.map { |card| card.to_s }).to include(river_card.to_s)
    expect(hand.best_five.length).to be(5)
    expect(hand.type).to eq(:full_house)
  end

  it 'computes all other hands for the same board' do
    expect(hand.other_hands_breakdown[:does_better_than]).to be_an(Array)
  end

end

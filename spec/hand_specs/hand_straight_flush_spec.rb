require "rspec"
require "card"
require "hand"
require "board"

# cards
ac = Card.new(:ace, :clubs)
  ad = Card.new(:ace, :diamonds)
  as = Card.new(:ace, :spades)
  ah = Card.new(:ace, :hearts)

  kc = Card.new(:king, :clubs)
  kd = Card.new(:king, :diamonds)
  ks = Card.new(:king, :spades)
  kh = Card.new(:king, :hearts)

  qd = Card.new(:queen, :diamonds)
  qh = Card.new(:queen, :hearts)
  qc = Card.new(:queen, :clubs)
  qs = Card.new(:queen, :spades)

  jd = Card.new(:jack, :diamonds)
  jh = Card.new(:jack, :hearts)
  jc = Card.new(:jack, :clubs)
  js = Card.new(:jack, :spades)

  td = Card.new(:ten, :diamonds)
  th = Card.new(:ten, :hearts)
  tc = Card.new(:ten, :clubs)
  ts = Card.new(:ten, :spades)

  nc = Card.new(:nine, :clubs)
  nd = Card.new(:nine, :diamonds)
  ns = Card.new(:nine, :spades)
  nh = Card.new(:nine, :hearts)

  ec = Card.new(:eight, :clubs)
  ed = Card.new(:eight, :diamonds)
  es = Card.new(:eight, :spades)
  eh = Card.new(:eight, :hearts)

  svd = Card.new(:seven, :diamonds)
  svh = Card.new(:seven, :hearts)
  svc = Card.new(:seven, :clubs)
  svs = Card.new(:seven, :spades)

  sxd = Card.new(:six, :diamonds)
  sxh = Card.new(:six, :hearts)
  sxc = Card.new(:six, :clubs)
  sxs = Card.new(:six, :spades)

  fvd = Card.new(:five, :diamonds)
  fvh = Card.new(:five, :hearts)
  fvc = Card.new(:five, :clubs)
  fvs = Card.new(:five, :spades)

  frd = Card.new(:four, :diamonds)
  frh = Card.new(:four, :hearts)
  frc = Card.new(:four, :clubs)
  frs = Card.new(:four, :spades)

  thd = Card.new(:three, :diamonds)
  thh = Card.new(:three, :hearts)
  thc = Card.new(:three, :clubs)
  ths = Card.new(:three, :spades)

  twd = Card.new(:two, :diamonds)
  twh = Card.new(:two, :hearts)
  twc = Card.new(:two, :clubs)
  tws = Card.new(:two, :spades)
board = Board.new

# FLOP
board.add_flop(jc, nc, tc)

jack_high_straight_flush = Hand.new([ec, svc], board)
king_high_straight_flush_on_the_turn = Hand.new([kc, twh], board)

describe 'straight flush' do

  it 'is recognized on the flop' do
    expect(jack_high_straight_flush.best_five.length).to be(5)
    expect(jack_high_straight_flush.cards.length).to be(5)
    expect(jack_high_straight_flush.type).to eq(:straight_flush)
    expect(king_high_straight_flush_on_the_turn.type).to eq(:high_card)
  end

  it 'recognizes a straight flush on turn' do
    #TuRn
    board.add_turn(qc)
    expect(king_high_straight_flush_on_the_turn.best_five.length).to be(5)
    expect(king_high_straight_flush_on_the_turn.cards.length).to be(6)
    expect(king_high_straight_flush_on_the_turn.type).to eq(:straight_flush)

  end

  it 'compares against other straight flush hands' do
    expect(jack_high_straight_flush < king_high_straight_flush_on_the_turn).to be(true)
  end

  it 'evaluates a straight flush when both a straight and flush exist but not the same cards' do
    pocket_aces = Hand.new([as, ah], board)
    royal_flush_on_the_river = Hand.new([ac, frh], board)
    garbage_hand = Hand.new([tws, nh], board)

    expect(pocket_aces > garbage_hand).to be(true)

    #river
    board.add_river(kc)

    expect(pocket_aces < royal_flush_on_the_river).to be(true)
    expect(pocket_aces.type).to eq(garbage_hand.type)

  end
end

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
board.add_flop(jc, nc, jh)

#TuRn
board.add_turn(fvs)

#River
board.add_river(ts)

jacks_over_nines = Hand.new([jd, nd], board)
nines_over_jacks = Hand.new([nh, ns], board)
jacks_over_tens = Hand.new([js, td], board)

describe 'full house' do

  it 'recognizes a full house hand' do
    expect(jacks_over_nines.best_five.length).to be(5)
    expect(nines_over_jacks.best_five.length).to be(5)
    expect(jacks_over_tens.best_five.length).to be(5)

    expect(jacks_over_nines.cards.length).to be(7)
    expect(nines_over_jacks.cards.length).to be(7)
    expect(jacks_over_tens.cards.length).to be(7)

    expect(jacks_over_nines.type).to eq(:full_house)
    expect(nines_over_jacks.type).to eq(:full_house)
    expect(jacks_over_tens.type).to eq(:full_house)
  end

  it 'compares against other full house hands' do
    expect(jacks_over_nines < jacks_over_tens).to be(true)
    expect(jacks_over_nines > nines_over_jacks).to be(true)
  end
end

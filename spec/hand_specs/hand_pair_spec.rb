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

board.add_flop(jc, tc, ec)
jacks_with_ten_kicker = Hand.new([tws, js], board)
tens_with_ace_kicker = Hand.new([as, ts], board)
tens_with_king_kicker = Hand.new([kd, td], board)
tens_with_king_kicker_again = Hand.new([kh, th], board)

board.add_turn(frs)

describe 'pair' do

  it 'recognizes a pair hand' do
    expect(jacks_with_ten_kicker.best_five.length).to be(5)
    expect(jacks_with_ten_kicker.cards.length).to be(6)
    expect(jacks_with_ten_kicker.type).to eq(:pair)
  end

  it 'has a kicker' do
    expect(jacks_with_ten_kicker.kicker.value).to eq(:ten)
    expect(tens_with_king_kicker.kicker.value).to eq(:king)
  end

  it 'compares against other pairs' do
    expect(tens_with_king_kicker.type).to eq(:pair)
    expect(tens_with_king_kicker_again.type).to eq(:pair)
    expect(tens_with_ace_kicker.type).to eq(:pair)

    expect(tens_with_king_kicker).to eq(tens_with_king_kicker_again)
    expect(tens_with_king_kicker_again < jacks_with_ten_kicker).to be(true)
    expect(tens_with_ace_kicker > tens_with_king_kicker).to be(true)
  end
end

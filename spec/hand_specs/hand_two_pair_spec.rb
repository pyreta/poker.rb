require "rspec"
require "card"
require "hand"
require "board"
# require_relative "./hand_test_setup.rb"

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

board.add_flop(jh, tc, kh)
jacks_and_tens = Hand.new([ts, jd], board)
ace_kicker = Hand.new([ac, tc], board)
king_kicker = Hand.new([fvc, td], board)

board.add_turn(frs)

describe 'two pair' do

  it 'recognizes a two pair hand' do
    expect(jacks_and_tens.best_five.length).to be(5)
    expect(jacks_and_tens.cards.length).to be(6)
    expect(jacks_and_tens.type).to eq(:two_pair)
  end

  it 'compares against other two pair hands' do
    jacks_and_tens_again = Hand.new([td, js], board)
    kings_and_tens = Hand.new([td, ks], board)
    kings_and_jacks = Hand.new([js, ks], board)

    expect(jacks_and_tens_again.type).to eq(:two_pair)
    expect(kings_and_tens.type).to eq(:two_pair)
    expect(kings_and_jacks.type).to eq(:two_pair)

    expect(jacks_and_tens).to eq(jacks_and_tens_again)
    expect(jacks_and_tens < kings_and_tens).to be(true)
    expect(kings_and_jacks > kings_and_tens).to be(true)
  end

  it 'can compare with using kicker' do
    board.add_river(jd)

    expect(ace_kicker.best_five.length).to be(5)
    expect(ace_kicker.cards.length).to be(7)

    expect(king_kicker.best_five.length).to be(5)
    expect(king_kicker.cards.length).to be(7)

    expect(ace_kicker > king_kicker).to be(true)
  end

  it 'has a kicker' do
    expect(king_kicker.kicker.value).to eq(:king)
    expect(ace_kicker.kicker.value).to eq(:ace)
  end

end

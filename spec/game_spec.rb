require "rspec"
require "game"
require "player"


describe Game do
  describe '#initialize' do
    it 'has default blinds' do
      game = Game.new
      expect(game.blinds).to eq("10/20")
    end

    it 'no limit by default' do
      game = Game.new
      expect(game.limit).to be_falsy
      game = Game.new(30,50,true)
      expect(game.limit).to be_truthy
    end

    it 'takes small and big blinds upon instantiation' do
      game = Game.new(30,50)
      expect(game.blinds).to eq("30/50")
    end

    it 'has a board' do
      game = Game.new
      expect(game.board).to be_a(Board)
    end

    it 'has a pot' do
      game = Game.new
      expect(game.pot).to be_a(Pot)
    end
  end

  describe 'adding players' do
    game = Game.new
    toby = Player.new(100, "Toby")
    luka = Player.new(100, "Luka")
    game.add_players([toby, luka])
    three_hundo = 300

    it 'adds a players to the game' do
      expect(game.players.include?(toby)).to be_truthy
      expect(game.players.include?(luka)).to be_truthy
      expect(game.players.length).to eq(2)
    end

    it 'shows only players that havent folded' do
      toby.fold
      expect(game.players_still_in_the_hand.length).to eq(1)
      expect(game.players.length).to eq(2)
    end

    it 'assigns the games pot to each player' do
      toby.unfold
      pot = game.pot
      pot.add three_hundo
      expect(toby.pot.money).to eq(300)
      expect(luka.pot.money).to eq(300)
    end

    it 'assigns the games board' do
      expect(toby.board).to equal(toby.board)
      game.dealer.deal
      expect(toby.hand.cards.length).to eq(2)
      game.board.add_flop(
        Card.new(:ace, :clubs),
        Card.new(:two, :clubs),
        Card.new(:four, :clubs),
      )
      expect(toby.hand.cards.length).to eq(5)
      expect(luka.hand.cards.length).to eq(5)
    end

    it 'tracks the position of every player' do
      expect(game.dealer_chip).to eq(toby)
      expect(game.small_blind).to eq(toby)
      expect(game.big_blind).to eq(luka)

      bobby = Player.new(100, 'Bobby')
      game.add_player(bobby)

      expect(game.dealer_chip).to eq(toby)
      expect(game.small_blind).to eq(luka)
      expect(game.big_blind).to eq(bobby)

      game.swap_players

      expect(game.dealer_chip).to eq(luka)
      expect(game.small_blind).to eq(bobby)
      expect(game.big_blind).to eq(toby)

      rick = Player.new(100, 'Rick')

      expect(game.dealer_chip).to eq(luka)
      expect(game.small_blind).to eq(bobby)
      expect(game.big_blind).to eq(toby)
      game.add_player(rick)
    end

    it 'takes blinds' do
      game.take_blinds
      expect(game.pot.money).to eq(game.small_blind_amount + game.big_blind_amount + three_hundo)
      expect(game.dealer_chip.money - game.small_blind.money).to eq(game.small_blind_amount)
      expect(game.dealer_chip.money - game.big_blind.money).to eq(game.big_blind_amount)
    end
  end

end

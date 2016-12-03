require './deck.rb'
require './board.rb'
require './hand.rb'
require './player.rb'
require './human_player.rb'
require './computer_player.rb'
require './pot.rb'
require './dealer.rb'

class Game

  attr_reader :players

  def initialize(small_blind = 10)
    @small_blind = small_blind
    @big_blind = small_blind * 2
    @players = []
    @all_players = []
    @pot = Pot.new
    @board = Board.new
    @dealer = Dealer.new(@players, @board)
    @street = :preflop
    @amount_to_call = @big_blind
  end

  def add_player(player)
    player.set_board(@board)
    player.set_pot(@pot)
    @players.push(player)
    @all_players.push(player)
  end

  def add_players(players)
    players.each do |player|
      add_player(player)
    end
  end

  def betting_order
    if @street == :preflop
      bbidx = @players.index(big_blind)
      order = @players[bbidx+1..-1] + @players[0..bbidx]
      return order
    end
    didx = @all_players.index(dealer_chip)
    order = @all_players[didx+1..-1] + @all_players[0..didx]
    order.select { |player| !player.fold }
  end

  def unsettle_hands
    @all_players.each { |player|  player.settled = false }
  end

  def take_bets
    show_standings
    unsettle_hands
    puts @board
    puts "____________________bets__________________________"
    puts ""
    puts "The pot has: #{@pot.money}"
    while true
      betting_order.each do |player|
        player.bet
      end
      break
      @players = @players.select { |player| !player.fold }
    end
  end

  def show_standings
    puts "Blinds: #{@small_blind}/#{@big_blind}".colorize(:blue)
    @all_players.each do |player|
      is_small = player == small_blind ? "small blind ".colorize(:red) : ""
      is_big = player == big_blind ? "big blind ".colorize(:red) : ""
      folded = player.fold ? "Folded" : ""
      is_dealer = player == dealer_chip ? "dealer ".colorize(:red) : ""
      space = 10 - player.name.length
      spacer=""
      space.times { spacer += "-" }
      puts "#{player.name}: #{spacer}$#{player.money.to_i.to_s.colorize(:green)} #{is_dealer}#{is_small}#{is_big}#{folded}"
    end
  end

  def winners
    rank = 0
    top_players = [@players[0]]
    @players[1..-1].each do |player|
      this_hand = player.hand
      top_hand = top_players[0].hand
      if (this_hand <=> top_hand) == 0
        top_players.push(player)
      elsif (this_hand <=> top_hand) == 1
        top_players = [player]
      end
    end
    puts ""
    if top_players.length > 1
      puts "Uh oh we have a tie!"
    else
      puts "#{top_players[0].name} wins $#{@pot.money}"
    end
    top_players
  end

  def settle_win
    @players.each do |player|
      puts "#{player.name} #{player.hand.pocket.join(" ")} has a #{player.rate_hand.to_s.split("_").join(" ")}"
    end
    all_winners = winners
    if all_winners.length == 1
      all_winners[0].win_money(@pot.redeem)
    else
      split = @pot.money/all_winners.length
      puts "money: #{@pot.money}"
      puts "winners: #{all_winners.length}"
      puts "split: #{split}"
      all_winners.each do |winner|
        winner.win_money(@pot.take(split))
      end
    end
  end

  def reset_players_money_in_pot
    @all_players.each { |player| player.money_in_the_pot = 0 }
  end

  def new_hand
    @board.clear
    @dealer.new_deck
    @players = [*@all_players]
    reset_players_money_in_pot
    @amount_to_call = @big_blind
  end

  def remove_losers
    @all_players = @all_players.select { |player| player.money > 0}
  end

  def start
    while true
      puts "____________________deal__________________________".colorize(:green)
      puts ""
      @street = :preflop
      take_blinds
      @players.each { |player| player.reset }
      @dealer.deal
      take_bets
      puts "____________________flop__________________________".colorize(:green)
      puts ""
      @street = :flop
      @dealer.flop
      take_bets
      puts "____________________turn__________________________".colorize(:green)
      puts ""
      @street = :turn
      @dealer.turn
      take_bets
      puts "____________________river__________________________".colorize(:green)
      puts ""
      @street = :river
      @dealer.river
      take_bets
      puts "____________________WINNER_________________________".colorize(:green)
      puts ""
      settle_win
      remove_losers
      swap_players
      new_hand
      if @all_players.length == 1
        puts "GAME OVER".colorize(:red)
        puts "#{@all_players[0].name.colorize(:yellow)} wins!"
        2.times { puts "" }
        break
      end
      sleep 2
    end
  end

  def swap_players
    @all_players.push(@all_players.shift)
  end

  def dealer_chip
    @all_players[0]
  end

  def small_blind
    return dealer_chip if @all_players.length == 2
    @all_players[1]
  end

  def big_blind
    return @all_players[1] if @all_players.length == 2
    @all_players[2]
  end

  def take_blinds
    small_blind.put_money_in_pot(@small_blind)
    big_blind.put_money_in_pot(@big_blind)
  end

  def play
    50.times { puts "" }
    d = Deck.new
    hand = [d.take_card, d.take_card]
    hand2 = [d.take_card, d.take_card]
    hand3 = [d.take_card, d.take_card]
    handclass = Hand.new(hand, @board)
    handclass2 = Hand.new(hand2, @board)
    handclass3 = Hand.new(hand3, @board)
    puts hand.join(" ")
    puts @board
    r = gets.chomp
    if r != "f"
      50.times { puts "" }
      @board.add_flop(d.take_card, d.take_card, d.take_card)
      puts hand.join(" ")
      puts @board
      r = gets.chomp
      50.times { puts "" }
      @board.add_turn(d.take_card)
      puts hand.join(" ")
      puts @board
      r = gets.chomp
      50.times { puts "" }
      @board.add_river(d.take_card)
      # puts suit_count(hand)
      puts hand2.join(" ")
      puts handclass2.rate_hand
      # p groups(hand2)
      # puts "high card: #{rate_hand(hand2)}"
      # puts "pair: #{pair(hand2)}"
      puts hand3.join(" ")
      puts handclass3.rate_hand
      # p groups(hand3)
      # puts "high card: #{rate_hand(hand3)}"
      # puts "pair: #{pair(hand3)}"
      puts ""
      puts hand.join(" ")
      # p groups(hand)
      # puts "high card: #{rate_hand(hand)}"
      # puts "pair: #{pair(hand)}"
      puts
      puts handclass.rate_hand
      # handclass.card_class_count.each do |k, v|
      #   puts k
      #   puts v.join(" ")
      # end
      puts @board
    end
    # p "pair: #{handclass.pair}"
    # p "set: #{handclass.set}"
    # p "full_house: #{handclass.full_house}"
    # p "four_of_a_kind: #{handclass.four_of_a_kind}"
    # puts handclass.high_card
    # puts "flush: #{handclass.flush.join(" ")}" if handclass.flush
    # puts "straight: #{handclass.straight.join(" ")}" if handclass.straight
    # puts "straight_flush: #{handclass.straight_flush.join(" ")}" if handclass.straight_flush
    # puts "royal_flush: #{handclass.royal_flush.join(" ")}" if handclass.royal_flush
  end

end


g = Game.new
# g.play
p1 = HumanPlayer.new('Louis')
p2 = ComputerPlayer.new('Jacob')
p3 = ComputerPlayer.new('Tom')
p4 = ComputerPlayer.new('Ronnie')
g.add_players([p1,p2,p3,p4])
# g.add_player(p1)
# g.add_player(p2)
# g.add_player(p3)
g.start

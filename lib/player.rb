
require 'colorize'

class Player
  @@players = 0

  def self.add_player
    @@players += 1
  end

  def self.number_of_players
    @@players
  end

  attr_reader :hand, :name, :board, :money, :pot
  attr_accessor :settled, :money_in_the_pot

  def initialize(opts = {})
    @money = opts[:money] || 0
    @name = opts[:name] || default_name
    @board = []
    @folded = false
    # @settled = false
    @money_in_the_pot = 0
    @hand = { hand_rank: nil }
  end

  def default_name
    self.class.add_player
    "player#{self.class.number_of_players}"
  end

  def folded?
    @folded
  end

  def fold
    fold_message
    @folded = true
  end

  def unfold
    @folded = false
  end

  # def reset
  #   @folded = false
  # end

  def evaluate_hand
    @hand.evaluate_hand
  end

  def starting_hand_rank
    @hand.starting_rank
  end

  def hand_rank
    @hand.rank
  end

  def fold_message
    puts "*** #{@name} folds. ***".colorize(:yellow)
  end

  def bet_message(bet_amount)
    puts "#{@name} #{"bets".colorize(:red)} #{bet_amount.to_s.colorize(:green)}"
  end

  def owes_money_to_pot?
    @pot.total_amount_to_call > @money_in_the_pot
  end

  def bet(bet_amount)
    fold if bet_amount == 'f'
    unless folded?
      bet_amount = max_bet(bet_amount)
      put_money_in_pot(bet_amount)
      @pot.total_amount_to_call = @money_in_the_pot unless owes_money_to_pot?
    end
  end

  def max_bet(bet_amount)
    bet_amount.to_i > @money ? @money : bet_amount.to_i
  end

  def put_money_in_pot(amount)
    bet_message(amount)
    @money_in_the_pot += amount
    @money -= amount
    @pot.add(amount)
  end

  def take_money_from_pot(amount)
    @money_in_the_pot -= amount
    @money += amount
    @pot.take(amount)
  end

  def win_pot
    take_money_from_pot(@pot.money)
  end

  # def needs_to_bet?
  #   (@pot.total_amount_to_call > @money_in_the_pot) && !folded?
  # end

  # def win_money(amount)
  #   @money += amount
  # end

  def set_hand(hand)
    @hand = hand
  end

  def set_pot(pot)
    @pot = pot
  end

  # def set_board(board)
  #   @board = board
  # end
end

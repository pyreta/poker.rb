
require 'colorize'

class Player
  attr_reader :hand, :name, :board, :money
  attr_accessor :fold, :settled, :money_in_the_pot

  def initialize(money = 300, name)
    @money = money
    @name = name
    @board = []
    @fold = false
    @settled = false
    @money_in_the_pot = 0
    @hand = { hand_rank: nil }
  end

  def reset
    @fold = false
  end

  def evaluate_hand
    @hand.evaluate_hand
  end

  def starting_hand_rank
    @hand.starting_rank
  end

  def hand_rank
    @hand.rank
  end

  def bet(bet_amount)
    if bet_amount == 'f'
      @fold = true
      puts "*** #{@name} folds. ***".colorize(:yellow)
    end
    unless @fold
      bet_amount = bet_amount.to_i > @money ? @money : bet_amount.to_i

      put_money_in_pot(bet_amount)

      if @pot.amount_to_call > @money_in_the_pot
        # puts "YOU DIDNT BET ENOUGH #{@name}! #{@pot.amount_to_call - @money_in_the_pot} short!"
      elsif @pot.amount_to_call <= @money_in_the_pot
        @pot.amount_to_call = @money_in_the_pot
        # puts "#{@pot.amount_to_call} is the new min bet!"
      end
      puts "#{@name} #{"bets".colorize(:red)} #{bet_amount.to_s.colorize(:green)}"
    end
  end

  def put_money_in_pot(amount)
    @money_in_the_pot += amount
    @money -= amount
    @pot.add(amount)
  end

  def needs_to_bet?
    (@pot.amount_to_call > @money_in_the_pot) && !@fold
  end

  def win_money(amount)
    @money += amount
  end

  def set_hand(hand)
    @hand = hand
  end

  def set_pot(pot)
    @pot = pot
  end

  def set_board(board)
    @board = board
  end
end

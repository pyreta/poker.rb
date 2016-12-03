
class Player
  attr_reader :hand, :name, :board, :money
  attr_accessor :fold, :settled, :money_in_the_pot

  def initialize(money = 6000, name)
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

  def rate_hand
    @hand.rate_hand
  end

  def hand_rank
    @hand.rank
  end

  def bet(bet_amount)
    @fold = true if bet_amount == 'f'
    bet_amount = bet_amount.to_i > @money ? @money : bet_amount.to_i
    @money_in_the_pot += bet_amount
    put_money_in_pot(bet_amount)
    puts "#{@name} #{"bets".colorize(:red)} #{bet_amount.to_s.colorize(:green)}"
  end

  def put_money_in_pot(amount)
    @money -= amount
    @pot.add(amount)
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

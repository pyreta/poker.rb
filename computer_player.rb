require 'colorize'

class ComputerPlayer < Player

  def initialize(name)
    @type = 'computer'
    super
  end

  def bet
    # sleep 1
    # puts "#{@name} has #{@money_in_the_pot} in the pot"
    bet = @pot.money / 4
    # bet = bet > @money ? @money : bet
    # @money_in_the_pot += bet
    # put_money_in_pot(bet)
    # puts "#{@name} #{"bets".colorize(:red)} #{bet.to_s.colorize(:green)}"
    # puts "#{@name} has #{@money_in_the_pot} in the pot"
    # @pot.add(bet)
    super(bet)
  end

  def set_hand(hand)
    @hand = hand
  end

  def set_board(board)
    @board = board
  end
end

require 'colorize'

class ComputerPlayer < Player

  def initialize(name)
    @type = 'computer'
    super
  end

  def bet(minimum)
    bet = @pot.money / 4
    super(bet, minimum)
  end

  def set_hand(hand)
    @hand = hand
  end

  def set_board(board)
    @board = board
  end
end

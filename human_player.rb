
class HumanPlayer < Player

  def initialize(name)
    @type = 'human'
    super
  end

  def bet(minimum)
    unless @fold
      puts @hand.hand.join(" ")
      print "#{@name}, make a bet: "
      bet = gets.chomp
      super(bet, minimum)
    end
  end

  def set_hand(hand)
    @hand = hand
  end

  def set_board(board)
    @board = board
  end
end

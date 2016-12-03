
class HumanPlayer < Player

  def initialize(name)
    @type = 'human'
    super
  end

  def bet
    unless @fold
      amount_to_call = @pot.amount_to_call - @money_in_the_pot
      amount_to_call = @money if amount_to_call > @money
      bet_string = amount_to_call > 0 ? "call $#{amount_to_call}, bet, or fold" : "check or bet"
      puts @hand.hand.join(" ")
      print "#{@name}, #{bet_string}: "
      bet = gets.chomp
      bet = amount_to_call if bet == "c"
      super(bet)
    end
  end

  def set_hand(hand)
    @hand = hand
  end

  def set_board(board)
    @board = board
  end
end

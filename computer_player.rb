require 'colorize'

class ComputerPlayer < Player

  def initialize(name)
    @type = 'computer'
    super
  end

  def bet
    amount_to_call = @pot.amount_to_call - @money_in_the_pot
    amount_to_call = @money if amount_to_call > @money
    four_bet = @pot.money / 4
    four_bet = amount_to_call if four_bet < amount_to_call
    bets = ["c", "c", "c", "c", "f", four_bet, four_bet]
    # bet = "c"
    # bet = @pot.money / 4
    bet = bets[rand(bets.length)]
    if bet == "f" and amount_to_call == 0
      bet = "c"
    end
    bet = amount_to_call if bet == "c"
    super(bet)
  end

  def set_hand(hand)
    @hand = hand
  end

  def set_board(board)
    @board = board
  end
end

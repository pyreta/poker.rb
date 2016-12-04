require 'colorize'

class ComputerPlayer < Player

  def initialize(name)
    @type = 'computer'
    @range = 9 - rand(6)
    super
  end

  def folding?
    return false if amount_to_call == 0
    starting_hand_rank <= @range
  end

  def amount_to_call
    calling_amount = @pot.amount_to_call - @money_in_the_pot
    calling_amount = @money if calling_amount > @money
    calling_amount
  end

  def bet(street)
    sleep 0.125
    # amount_to_call = @pot.amount_to_call - @money_in_the_pot
    # amount_to_call = @money if amount_to_call > @money
    four_bet = @pot.money / 4
    four_bet = amount_to_call if four_bet < amount_to_call
    bets = ["c", "c", "c", "c", four_bet, four_bet]
    # bet = "c"
    # bet = @pot.money / 4
    bet = bets[rand(bets.length)]
    bet = "f" if folding?
    bet = "f" if (rand(9) == 2) && (street != :preflop) && (amount_to_call > 0)
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

require 'colorize'

class ComputerPlayer < Player

  def initialize(name)
    @type = 'computer'
    @range = 9 - rand(6)
    super
  end

  # def folding?
  #   return false if amount_to_call == 0
  #   starting_hand_rank <= @range
  # end

  def folding?
    return false if amount_to_call == 0
    if @hand.board.all == []
      starting_hand_rank > @range
    else
      # binding.pry
      amount_to_call > max_bet(winning_percentage)
    end
  end

  def max_bet(win_percent)
    (@pot.money * win_percent * 100).to_i / 100
  end

  def amount_to_call
    calling_amount = @pot.total_amount_to_call - @money_in_the_pot
    calling_amount = @money if calling_amount > @money
    calling_amount
  end

  def round_bet_to_pot_fraction

  end

  def calculate_bet
    return "f" if folding?
    four_bet = @pot.money / 4
    four_bet = amount_to_call if four_bet < amount_to_call
    bets = ["c", "c", "c", "c", four_bet, four_bet]
    bets[rand(bets.length)]
  end

  def bet(street)
    sleep 0.125
    # amount_to_call = @pot.total_amount_to_call - @money_in_the_pot
    # amount_to_call = @money if amount_to_call > @money
    # bet = "c"
    # bet = @pot.money / 4
    bet = calculate_bet
    # bet = "f" if folding?
    # bet = "f" if (rand(9) == 2) && (street != :preflop) && (amount_to_call > 0)
    bet = amount_to_call if bet == "c"
    super(bet)
  end

  def set_hand(hand)
    @hand = hand
  end

  def set_board(board)
    @board = board
  end

  def opposing_hand_breakdown
    player_range = 6
    hands = { does_better_than: [], does_the_same_as: [], does_worse_than: [], flush_draw: [], straight_draw: [] }
    total = 0
    d = Deck.new.cards.sort_by { |card| card.rank }
    card_strings = @hand.cards.map { |card| card.to_s }
    @hand.evaluate_hand
    d[0...-1].each_with_index do |card1, idx|
      next if card_strings.include?(card1.to_s)
      d[idx+1..-1].each do |card2|
        next if card_strings.include?(card2.to_s)
        hand = Hand.new([card1,card2], @board)
        if hand.starting_rank <= player_range
          # puts @hand.cards.join(" ")
          hands[:does_better_than].push(hand) if self.hand > hand
          hands[:does_the_same_as].push(hand) if self.hand == hand
          hands[:does_worse_than].push(hand) if self.hand < hand
          hands[:flush_draw].push(hand) if hand.flush_draw?
          hands[:straight_draw].push(hand) if hand.straight_draw?
          total += 1
        end
      end
    end
    hands[:total] = total
    hands
  end

  def hands_stats_printout
    player_range = 6
    hands = opposing_hand_breakdown
    # puts @board
    puts "#{(@name + "'s hand: ").colorize(:red)}: #{@hand.pocket.join(" ")}"
    puts "#{(hands[:does_better_than].length / hands[:total].to_f * 100).to_i}% #{@name}'s hand does better than other hands"
    puts "#{(hands[:does_the_same_as].length / hands[:total].to_f * 100).to_i}% #{@name}'s hand does the same as than other hands"
    puts "#{(hands[:does_worse_than].length / hands[:total].to_f * 100).to_i}% #{@name}'s hand does does worse than other hands"
    puts "#{(hands[:flush_draw].length / hands[:total].to_f * 100).to_i}% of other hands are on a flush draw"
    puts "#{(hands[:straight_draw].length / hands[:total].to_f * 100).to_i}% of other hands are on a straight draw"
    # puts hands[:does_worse_than].map { |hand| hand.pocket.join(" ") }
    puts "#{@name} loses against #{hands[:does_worse_than].length} hands out of #{hands[:total]} against a player with a #{player_range} range"
    percent_win = hands[:does_better_than].length / hands[:total].to_f
    puts "if the pot is #{@pot.money}, you should call a max of #{max_bet(percent_win)}"
  end

  def winning_percentage
    hands = opposing_hand_breakdown
    # puts @board
    # puts "#{(@name + "'s hand: ").colorize(:red)}: #{@hand.pocket.join(" ")}"
    # puts "#{(hands[:does_better_than].length / total.to_f * 100).to_i}% #{@name}'s hand does better than other hands"
    # puts "#{(hands[:does_the_same_as].length / total.to_f * 100).to_i}% #{@name}'s hand does the same as than other hands"
    # puts "#{(hands[:does_worse_than].length / total.to_f * 100).to_i}% #{@name}'s hand does does worse than other hands"
    # puts "#{(hands[:flush_draw].length / total.to_f * 100).to_i}% of other hands are on a flush draw"
    # puts "#{(hands[:straight_draw].length / total.to_f * 100).to_i}% of other hands are on a straight draw"
    # # puts hands[:does_worse_than].map { |hand| hand.pocket.join(" ") }
    # puts "#{@name} loses against #{hands[:does_worse_than].length} hands out of #{hands[:total]} against a player with a #{player_range} range"
    hands_stats_printout
    hands[:does_better_than].length / hands[:total].to_f
    # puts "if the pot is #{@pot.money}, you should call a max of #{max_bet(percent_win)}"
  end
end

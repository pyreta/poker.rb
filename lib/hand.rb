require_relative './card'
require_relative './deck'
require_relative './board.rb'
require 'pry'

class Hand
  STARTING_RANKS = {
    1 => ['AA', 'KK', 'JJ', 'QQ', 'AKs'],
    2 => ['TT', 'AQs', 'AJs', 'KQs', 'AKo'],
    3 => ['99', 'ATs', 'KJs', 'QJs', 'JTs', 'AQo'],
    4 => ['88', 'KTs', 'QTs', 'J9s', 'T9s', '98s', 'AJo', 'KQo'],
    5 => ['77', 'A9s', 'A8s', 'A7s', 'A6s', 'A5s', 'A4s', 'A3s', 'A2s', 'Q9s', 'T8s', '97s', '87s', '76s', 'KJo', 'QJo', 'JTo'],
    6 => ['66', '55', 'K9s', 'J8s', '86s', '75s', '54s', 'ATo', 'KTo', 'QTo', '65s'],
    7 => ['44', '33', '22', 'K8s', 'K7s', 'K6s', 'K5s', 'K4s', 'K3s', 'K2s', 'Q8s', 'T7s', '64s', '53s', '43s', 'J9o', 'T9o', '98o'],
    8 => ['J7s', '96s', '85s', '74s', '42s', '32s', 'A9o', 'K9o', 'Q9o', 'J8o', 'T8o', '87o', '76o', '65o', '54o']
  }

  def self.starting_ranks
    STARTING_RANKS
  end

  attr_reader :hand, :rank, :hand_object

  def initialize(starting_two_cards, board)
    @hand = starting_two_cards.sort_by { |card| card.rank }.reverse()
    @board = board
    @best_five = nil
    @hand_object = nil
  end


  def cards
    (@hand + @board.all).sort_by { |card| card.rank }.reverse()
  end

  def best_five
    evaluate_hand if cards.length >= 5
    # evaluate_hand if cards.length >= 5 && !@hand_object
    @best_five
  end

  # def cards
  #   @hand.sort_by { |card| card.rank }.reverse()
  # end
  def type
    if @hand_object
      return @hand_object[:type]
    elsif cards.length >= 5
      evaluate_hand
      return @hand_object[:type]
    end
    nil
  end

  def kicker
    if @hand_object && @hand_object[:kicker]
      return @hand_object[:kicker][0]
    elsif @hand_object && @hand_object[:other_cards]
      return @hand_object[:other_cards][0]
    elsif cards.length >= 5
      evaluate_hand
      return @hand_object[:kicker][0] if @hand_object[:kicker]
      return @hand_object[:other_cards][0] if @hand_object[:other_cards]
    end
    nil
  end

  def suited?
    @hand[0].suit == @hand[1].suit
  end

  def pocket_pair?
    @hand[0].value == @hand[1].value
  end

  def card_class_count
    values = {}
    cards.each do |card|
      if values[card.value]
        values[card.value].push(card)
      else
        values[card.value]=[card]
      end
    end
    values
  end

  def notation
    values_string = @hand.map { |card| Card.card_values[card.value] }.join
    if pocket_pair?
      return values_string
    elsif suited?
      return values_string + "s"
    end
    return values_string + "o"
  end

  def starting_rank
    Hand.starting_ranks.each do |rank, hand_notations|
      return rank if hand_notations.include?(notation)
    end
    9
  end

  def card_count
    values = Hash.new(0)
    cards.each do |card|
      values[card.value] += 1
    end
    values
  end

  def rank
    evaluate_hand unless @hand_object
    [:nothing,:high_card,:pair,:two_pair,:set,:straight,:flush,:full_house,:four_of_a_kind,
      :straight_flush,:royal_flush].index(@hand_object[:type])
  end

  def evaluate_hand
    if royal_flush; elsif straight_flush; elsif four_of_a_kind; elsif full_house
    elsif flush; elsif straight; elsif set; elsif two_pair; elsif pair; else high_card
    end
    return "#{@hand_object[:type]}: #{@best_five.join(" ")}"
  end
  def groups
    groups = {}
    cards.each do |card|
      if groups[card.value]
        groups[card.value].push(card)
      else
        groups[card.value] = [card]
      end
    end
    full_groups = {}
    groups.each do |k,v|
      if full_groups[v.length]
        full_groups[v.length].push(v)
      else
        full_groups[v.length] = [v]
      end
    end
    full_groups
  end

  def suit_groups
    suits = {}
    cards.each do |card|
      if suits[card.suit_class.suit]
        suits[card.suit_class.suit].push(card)
      else
        suits[card.suit_class.suit] = [card]
      end
    end
    suits
  end

  def royal_flush
    sf = straight_flush
    # binding.pry
    if sf && (sf[:cards][0].value == :ace)
      @hand_object = { cards: sf[:cards], type: :royal_flush }
      @hand_rank = 10
      @best_five = sf[:cards]
      return @hand_object
    end
    false
  end

  def straight_flush
    flushy = flush?
    if flushy && (flushy[:cards][0].straight_values == flushy[:cards].map { |card| card.value })
      @hand_object = { cards: flushy[:cards], type: :straight_flush }
      @best_five = flushy[:cards]
      # binding.pry
      return @hand_object
    end
    false
  end

  def four_of_a_kind
    if groups[4]
      other_cards = cards.select { |card| card.value != groups[4][0][0].value }.sort_by { |kard| kard.rank }.reverse
      kicker = other_cards[0]
      @best_five = groups[4][0] + [kicker]
      @hand_object = { quad: groups[4], kicker: kicker, type: :four_of_a_kind}
      return @hand_object
    end
    false
  end

  def full_house
    if (groups[3] && groups[2]) || (groups[3] && groups[3].length > 1)
      set = groups[3][0]
      pair = groups[2] ? groups[2][0] : groups[3][1][0..1]
      @best_five = set + pair
      @hand_object = { set: set, pair: pair, type: :full_house }
      return @hand_object
    end
    false
  end

  def flush?
    flush = false
    suit_groups.values.each do |value|
      if value.length >= 5
        flush = { cards: value[0...5], type: :flush }
      end
    end
    flush
  end

  def flush
    flush = flush?
    if flush
      @best_five = flush[:cards]
      @hand_object = flush
    end
    flush
  end
  #
  # def flush
  #   flush = false
  #   suit_groups.values.each do |value|
  #     if value.length >= 5
  #       flush = { cards: value[0...5], type: :flush }
  #       @best_five = flush[:cards]
  #       @hand_object = flush
  #     end
  #   end
  #   flush
  # end

  def flush_draw?
    suit_groups.values.each do |value|
      if value.length == 4
        return value[0].suit
      end
    end
    false
  end

  def pocket
    @hand
  end

  def straight
    # card_values = cards.sort_by {|card| card.rank }.map { |card| card.value }.reverse
    card_values = cards.map { |card| card.value }.reverse
    cards.each do |card|
      card_classes = []
      straight = card.straight_values
      straight.each_with_index do |straight_value, idx|
        break unless card_values.include?(straight_value)
        straight_card = cards.select { |card| card.value == straight_value }[0]
        card_classes.push(straight_card)
        if idx == (straight.length - 1)
          @best_five = card_classes
          @hand_object = { cards: card_classes, type: :straight}
          return @hand_object
        end
      end
    end
    false
  end

  def straight_draw?
    draws = []
    card_values = cards.map { |card| card.value }.reverse
    cards.each do |card|
      missing = []
      straight = card.straight_values
      straight.each_with_index do |straight_value, idx|
        unless card_values.include?(straight_value)
          missing.push(idx)
        end
        # break unless card_values.include?(straight_value)
        # straight_card = cards.select { |card| card.value == straight_value }[0]
        # card_classes.push(straight_card)
        # if idx == (straight.length - 1)
        #   return true
        # end
      end
      draws.push(missing)
    end
    false
    straightest = draws.sort_by { |draws| draws.length }[0]
    if straightest.length == 1
      return :open_ended if [1,4].include?(straightest[0])
      return :gut_shot
    end
    false
  end

  def set
    if groups[3]
      @hand_object = { set: groups[3][0], other_cards: groups[1].map {|cards| cards[0]}[0...2], type: :set }
      @best_five = @hand_object[:set] + @hand_object[:other_cards]
      return @hand_object
    end
    false
  end

  def two_pair
    if (groups[2] && groups[2].length > 1)
      pairs = (groups[2][0] + groups[2][1])
      if groups[1]
        kicker = (groups[2][2] ? (groups[2][2] + (groups[1].map do |cards|
          cards[0] end)).sort_by { |card| card.rank }.reverse() : groups[1])[0]
      else
        kicker = groups[2][2][0]
      end
      @hand_object = { pairs: pairs, kicker: kicker, type: :two_pair }
      @best_five = @hand_object[:pairs].flatten + [@hand_object[:kicker]].flatten
      return @hand_object
    end
    false
  end

  def pair
    if groups[2]
      @hand_object = { pair: groups[2][0], other_cards: groups[1].map {|cards| cards[0]}[0...3], type: :pair }
      @best_five = @hand_object[:pair] + @hand_object[:other_cards]
      return @hand_object
    end
    false
  end

  def high_card
    @best_five = cards[0...5]
    @hand_object = { high_card: cards[0], other_cards: cards[1...5], type: :high_card }
  end

  def break_tie(other_hand)
    @best_five.each_with_index do |card, idx|
      other_card = other_hand.best_five[idx]
      return 1 if card.rank > other_card.rank
      return -1 if card.rank < other_card.rank
    end
    0
  end

  def possibilities
    turn_deck = Deck.new.cards.sort_by { |card| card.rank }
    turn_deck.each do |turn_card|
      unless cards.map { |hand_card| hand_card.to_s }.include?(turn_card.to_s)
        turn_hand = Hand.new(cards+[turn_card], [])
        turn_hand.evaluate_hand
        evaluate_hand
        if (turn_hand.rank > self.rank)
          puts "#{"If the turn is a".colorize(:blue)} #{turn_card}:"
          puts "Your hand will go from a:"
          puts evaluate_hand
          puts "to a:"
          puts turn_hand.evaluate_hand
          puts ""
          # river_deck = Deck.new.cards.sort_by { |card| card.rank }
          # river_deck.each do |river_card|
          #   unless cards.map { |hand_card| hand_card.to_s }.include?(river_card.to_s) || (turn_card.to_s == river_card.to_s)
          #     river_hand = Hand.new(cards+[turn_card]+[river_card], [])
          #     river_hand.evaluate_hand
          #     if (river_hand.rank > turn_hand.rank)
          #       puts "---------#{"If the river is a".colorize(:red)} #{river_card}:"
          #       puts "---------Your hand will go from a:"
          #       puts turn_hand.evaluate_hand
          #       puts "---------to a:"
          #       puts river_hand.evaluate_hand
          #       puts ""
          #     end
          #   end
          # end
        end
      end
    end
  end

  def max_bet(pot_size, win_percent)
    (pot_size * win_percent * 100).to_i / 100
  end

  def unknown_cards
    d = []
    card_strings = cards.map { |card| card.to_s }
    Deck.new.cards.each do |card|
      d.push(card) unless card_strings.include?(cards.to_s)
    end
    d.sort_by { |card| card.rank }
  end

  def other_hands_breakdown
    hands = { does_better_than: [], does_the_same_as: [], does_worse_than: [], flush_draw: [], straight_draw: [], total: 0 }
    total = 0
    all_other_cards = unknown_cards
    evaluate_hand
    all_other_cards[0...-1].each_with_index do |card1, idx|
      all_other_cards[idx+1..-1].each do |card2|
        hand = Hand.new([card1,card2], @board)
        if hand.starting_rank <= opponent_range
          hands[:does_better_than].push(hand) if self > hand
          hands[:does_the_same_as].push(hand) if self == hand
          hands[:does_worse_than].push(hand) if self < hand
          hands[:flush_draw].push(hand) if hand.flush_draw?
          hands[:straight_draw].push(hand) if hand.straight_draw?
          hands[:total] += 1
        end
      end
    end
    hands
  end

  def opponent_range(opponent = nil)
    6
  end

  def winning_percentage
    hands = other_hands_breakdown
    puts @board
    puts "#{"Your hand".colorize(:red)}: #{pocket.join(" ")}"
    puts "#{(hands[:does_better_than].length / hands[:total].to_f * 100).to_i}% your hand does better than other hands"
    puts "#{(hands[:does_the_same_as].length / hands[:total].to_f * 100).to_i}% your hand does the same as than other hands"
    puts "#{(hands[:does_worse_than].length / hands[:total].to_f * 100).to_i}% your hand does does worse than other hands"
    puts "#{(hands[:flush_draw].length / hands[:total].to_f * 100).to_i}% of other hands are on a flush draw"
    puts "#{(hands[:straight_draw].length / hands[:total].to_f * 100).to_i}% of other hands are on a straight draw"
    # puts hands[:does_worse_than].map { |hand| hand.pocket.join(" ") }
    puts "you lose against #{hands[:does_worse_than].length} hands out of #{hands[:total]} against a player with a #{opponent_range} range"
    pot_size = 114
    percent_win = hands[:does_better_than].length / hands[:total].to_f
    puts "if the pot is #{pot_size}, you should call a max of #{max_bet(pot_size, percent_win)}"
  end

  def <=>(other_hand)
    # other_hand.evaluate_hand
    return -1 if other_hand.rank > rank
    return 1 if other_hand.rank < rank
    break_tie(other_hand)
  end

  def <(other_hand)
    (self <=> other_hand) < 0
  end

  def >(other_hand)
    (self <=> other_hand) > 0
  end

  def ==(other_hand)
    (self <=> other_hand) == 0
  end

end

ac = Card.new(:ace, :clubs)
ad = Card.new(:ace, :diamonds)
as = Card.new(:ace, :spades)
ah = Card.new(:ace, :hearts)
qd = Card.new(:queen, :diamonds)
qh = Card.new(:queen, :hearts)
kc = Card.new(:king, :clubs)
qc = Card.new(:queen, :clubs)
jc = Card.new(:jack, :clubs)
tc = Card.new(:ten, :clubs)
td = Card.new(:ten, :diamonds)
two = Card.new(:two, :hearts)
fourd = Card.new(:four, :diamonds)
fourc = Card.new(:four, :clubs)
fours = Card.new(:four, :spades)
fiveh = Card.new(:five, :hearts)
fourh = Card.new(:four, :hearts)
nh = Card.new(:nine, :hearts)
nc = Card.new(:nine, :clubs)
nd = Card.new(:nine, :diamonds)
thh = Card.new(:three, :hearts)
sixs = Card.new(:six, :spades)

b = Board.new
b.add_flop(ac,thh,fourd)
# b.add_turn(as)
# b.add_river(nd)

cards2 = [tc, ah]
h2 = Hand.new(cards2, b)
# h2.other_hands_breakdown.each do |k,v|
#   puts k
#   unless v.is_a?(Integer)
#     v.each do |hand|
#       puts "#{hand.pocket.join(" ")}: #{hand.type}"
#     end
#   end
#   puts
# end
h2.winning_percentage

# cards1 = [ac, ad]
# h = Hand.new(cards1, [])
# puts h.starting_rank


# random_2 = Deck.new.cards[0..1]

# p h2.winning_percentage
# h2 = Hand.new(random_2, b)
# p h2.straight_draw?
# h2.possibilities

# puts h.evaluate_hand
# puts h.rank
# puts h2.evaluate_hand
# puts h2.rank
# puts h <=> h2

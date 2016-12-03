require './card'

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

  attr_reader :hand, :rank, :best_five, :hand_object

  def initialize(hand, board)
    @hand = hand.sort_by { |card| card.rank }.reverse()
    @board = board
    @best_five = nil
    @hand_object = nil
  end


  # def cards
  #   (@hand + @board.all).sort_by { |card| card.rank }.reverse()
  # end


  def cards
    @hand.sort_by { |card| card.rank }.reverse()
  end

  def suited?
    @hand[0].suit == @hand[1].suit
  end

  def pocket_pair?
    @hand[0].value == @hand[1].value
  end

  # def connectors?
  #   spaced_by?(1)
  # end
  #
  # def spaced_by?(amount)
  #   vals = Card.card_values.keys
  #   vals.index(@hand[0].value) == (vals.index(@hand[1].value) + amount)
  # end

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

  # def top_card_rank
  #   Card.card_values.keys.index(@hand[0].value)
  # end
  #
  # def kicker_rank
  #   Card.card_values.keys.index(@hand[1].value)
  # end
  #
  # def top_card_at_least_a(value)
  #   card_vals = Card.card_values.keys
  #   top_card_rank >= card_vals.index(value)
  # end

  def notation
    values_string = @hand.map { |card| Card.card_values[card.value] }.join
    if pocket_pair?
      return values_string
    elsif suited?
      return values_string + "s"
    end
    return values_string + "o"
  end

  def starting_rating
    Hand.starting_ranks.each do |rank, hand_notations|
      return rank if hand_notations.include?(notation)
    end
    9
  end

  # def starting_rating
  #   if pocket_pair?
  #     return 1 if top_card_at_least_a(:jack)
  #     return 2 if top_card_at_least_a(:ten)
  #     return 3 if top_card_at_least_a(:nine)
  #     return 4 if top_card_at_least_a(:eight)
  #     return 5 if top_card_at_least_a(:seven)
  #     return 6 if top_card_at_least_a(:five)
  #     return 7
  #   elsif connectors?
  #     if suited?
  #       return 1 if top_card_at_least_a(:ace)
  #       return 2 if top_card_at_least_a(:king)
  #       return 3 if top_card_at_least_a(:jack)
  #       return 4 if top_card_at_least_a(:nine)
  #       return 5 if top_card_at_least_a(:seven)
  #       return 6 if top_card_at_least_a(:five)
  #       return 7 if top_card_at_least_a(:four)
  #       return 8 if top_card_at_least_a(:three)
  #     else
  #       return 2 if top_card_at_least_a(:ace)
  #       return 4 if top_card_at_least_a(:king)
  #       return 5 if top_card_at_least_a(:jack)
  #       return 7 if top_card_at_least_a(:nine)
  #       return 8 if top_card_at_least_a(:five)
  #     end
  #   elsif spaced_by?(2)
  #     if suited?
  #       return 2 if top_card_at_least_a(:ace)
  #       return 3 if top_card_at_least_a(:king)
  #       return 4 if top_card_at_least_a(:jack)
  #       return 5 if top_card_at_least_a(:nine)
  #       return 6 if top_card_at_least_a(:seven)
  #     else
  #     end
  #   end
  #   9
  # end

  def card_count
    values = Hash.new(0)
    cards.each do |card|
      values[card.value] += 1
    end
    values
  end

  def rank
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
    groups
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
    if straight_flush && straight[:cards][0].value == :ace
      @hand_object = { cards: straight[:cards], type: :royal_flush }
      @hand_rank = 10
      return @hand_object
    end
    false
  end

  def straight_flush
    if straight && flush && (straight[:cards].join == flush[:cards].join)
      @hand_object = { cards: straight[:cards], type: :straight_flush }
      return @hand_object
    end
    false
  end

  def four_of_a_kind
    if groups[4]
      @best_five = groups[4] + groups[1][0]
      @hand_object = { quad: groups[4], kicker: groups[1][0][0], type: :four_of_a_kind}
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

  def flush
    flush = false
    suit_groups.values.each do |value|
      if value.length >= 5
        flush = { cards: value[0...5], type: :flush }
        @best_five = flush[:cards]
        @hand_object = flush
      end
    end
    flush
  end

  def pocket
    @hand
  end

  def straight
    card_values = cards.sort_by {|card| card.rank }.map { |card| card.value }.reverse
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
      kicker = (groups[2][2] ? (groups[2][2] + groups[1].map do |cards|
        cards[0] end).sort_by { |card| card.rank }.reverse() : groups[1])[0]
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

  def <=>(other_hand)
    return -1 if other_hand.rank > rank
    return 1 if other_hand.rank < rank
    break_tie(other_hand)
  end
end

ac = Card.new(:ace, :clubs)
ad = Card.new(:ace, :diamonds)
as = Card.new(:ace, :spades)
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
thh = Card.new(:three, :hearts)
sixs = Card.new(:six, :spades)

cards1 = [ac, ad]
h = Hand.new(cards1, [])
puts h.starting_rating
#
# cards2 = [kc, qc, jc, fourh, tc, thh, ad]
# h2 = Hand.new(cards2, [])
#
# puts h.evaluate_hand
# puts h.rank
# puts h2.evaluate_hand
# puts h2.rank
# puts h <=> h2

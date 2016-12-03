

class Pot
  attr_accessor :amount_to_call

  def initialize(start = 0)
    @money = start
    @amount_to_call = 0
  end

  def money
    @money
  end

  def add(amount)
    @money += amount
  end

  def take(amount)
    if amount > @money
      max_take = @money
      @money = 0
      max_take
    else
      @money -= amount
      amount
    end
  end

  def redeem
    amount = @money
    @money = 0
    amount
  end
end

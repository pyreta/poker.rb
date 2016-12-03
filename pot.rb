class Pot
  def initialize(start = 0)
    @money = start
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

class SubwayCentral
  attr_reader :ride_cost
  def initialize(ride_cost)
    self.ride_cost=(ride_cost)
  end

  def ride_cost=(ride_cost)
    raise "Invalid Ride Cost" unless ride_cost.is_a?(Numeric) && ride_cost.positive?
    @ride_cost = ride_cost
  end

  def to_s
    "Subway Central [$#{@ride_cost}]"
  end
end

class SubwayCard
  @subway_central
  def initialize
    raise "This method should be overwritten"
  end

  def ride?
    raise "Cannot use this card"
  end

  def ride
    raise "Cannot use this card"
  end

  def to_s
    "Subway Card [Central: #{@subway_central}]"
  end
end

class FixedSubwayCard < SubwayCard
  def initialize(subway_central, rides)
    @subway_central = subway_central
    raise "Invalid Rides" unless rides.is_a?(Integer) && rides.positive?
    @rides = rides
  end
  private def ride?
    @rides.positive?
  end
  def ride
    raise "No rides available" unless ride?
    @rides -= 1
  end

  def to_s
    "Fixed #{super} [Rides: #{@rides}"
  end
end

class RechargeableSubwayCard < SubwayCard
  def initialize(subway_central)
    @subway_central = subway_central
    @balance = 0
  end

  def ride?
    (@balance - @subway_central.ride_cost).positive?
  end

  def ride
    raise "Cannot ride" unless ride?
    @balance -= @subway_central.ride_cost
  end

  def recharge(amount)
    raise "Invalid amount" unless amount.is_a?(Numeric) && amount.positive?
    @balance += amount
  end

  def to_s
    "Rechargeable #{super} [Balance: $#{@balance}]"
  end
end

class DiscountRechargeableSubwayCard < RechargeableSubwayCard
  def initialize(subway_central, discount_percentage)
    super(subway_central)
    raise "Invalid Discount" unless discount_percentage.is_a?(Numeric) && discount_percentage >= 0 && discount_percentage <= 1
    @discount_percentage = discount_percentage
  end
  private def ride_cost
    @subway_central.ride_cost * (1 - @discount_percentage)
  end
end

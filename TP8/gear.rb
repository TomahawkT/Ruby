class Gear
  def initialize(chainring, cog, rim, tire)
    @chainring = chainring
    @cog = cog
    @wheel = Wheel.new(rim,tire)
  end
  def ratio
    @chainring/@cog.to_f
  end
  def gear_inches
    ratio * @wheel.diameter
  end
end

class Wheel
  def initialize(rim, tire)
    @rim = rim
    @tire = tire
  end

  def diameter
    @rim + (@tire*2)
  end
end

class FlightCatalog

  def initialize
    @flights = Hash.new
  end

  def add_flight(flight)
    @flights[flight.code] = flight
  end

  def get_flight(flight_code)
    @flights[flight_code]
  end
end

class Flight

  attr_reader :code, :airline, :price, :miles

  def initialize(code, airline, price, miles)
    @code = code
    @airline = airline
    @price = price
    @miles = miles
  end
end

class FlightOperator
  def initialize(catalog)
    @catalog = catalog
  end

  def miles_status(member, airline)
    "Millas de #{member.name} en #{airline}: #{member.get_miles(airline)}\n"
  end

  def buy_flight(flight_code, member)
    flight = @catalog.get_flight(flight_code)
    raise 'Flight not found' if flight.nil?
    return 0 if member.redeem_miles?(flight)
    member.add_miles(flight)
    flight.price
  end

end

class Category
  def initialize
    raise 'Class is abstract'
  end

  def calculate_miles(current_miles, flight_miles)
    unlimited_miles = current_miles + flight_miles * @miles_multiplier
    return unlimited_miles unless reached_limit(unlimited_miles)
    miles_limit
  end

  private

  def init(miles_multiplier)
    @miles_multiplier = miles_multiplier
  end

  def reached_limit(balance_miles)
    balance_miles > miles_limit
  end

  def miles_limit
    raise 'Method is abstract'
  end
end

class Member
  attr_reader :name, :category

  def initialize(name, category)
    @name = name
    @category = category
    @miles_by_airline = Hash.new { 0 }
  end

  def add_miles(flight)
    current_miles_balance = @miles_by_airline[flight.airline]
    new_miles_balance = @category.calculate_miles(current_miles_balance, flight.miles)
    @miles_by_airline[flight.airline] = new_miles_balance
  end

  def get_miles(airline)
    @miles_by_airline[airline]
  end

  def redeem_miles?(flight)
    return false unless @miles_by_airline[flight.airline] >= flight.miles
    @miles_by_airline[flight.airline] -= flight.miles
    true
  end
end

class StandardCategory < Category
  MILES_MULTIPLIER = 1
  MILES_LIMIT = 1000

  def initialize
    init(MILES_MULTIPLIER)
  end

  def miles_limit
    MILES_LIMIT
  end
end
class GoldCategory <
  Category
  MILES_MULTIPLIER = 1.10
  MILES_LIMIT = 2000

  def initialize
    init(MILES_MULTIPLIER)
  end

  def miles_limit
    MILES_LIMIT
  end
end
class PlatinumCategory <
  Category
  MILES_MULTIPLIER = 1.25

  def initialize
    init(MILES_MULTIPLIER)
  end

  private

  def reached_limit(balance_miles)
    false
  end
end






flight_catalog = FlightCatalog.new

flight_catalog.add_flight(Flight.new('LA1','LATAM',200,600))
flight_catalog.add_flight(Flight.new('LA2','LATAM',400,3000))
flight_catalog.add_flight(Flight.new('LA3','LATAM',40,200))
flight_catalog.add_flight(Flight.new('UA1','United',3500,5000))

flight_operator = FlightOperator.new(flight_catalog)

juan = Member.new('Juan', GoldCategory.new) # Juan tiene Categoría Gold

puts flight_operator.miles_status(juan, 'United') # 0
puts flight_operator.miles_status(juan, 'LATAM') # 0

puts flight_operator.buy_flight('UA1', juan) # 3500

puts flight_operator.miles_status(juan, 'United') # 2000 por el tope de categoría
puts flight_operator.miles_status(juan, 'LATAM') # 0

malena = Member.new('Malena', PlatinumCategory.new) # Malena tiene Categoría Platinum

puts flight_operator.miles_status(malena, 'United') # No registra millas
puts flight_operator.miles_status(malena, 'LATAM') # No registra millas

puts flight_operator.buy_flight('UA1', malena) # 3500
puts flight_operator.buy_flight('LA1', malena) # 200

puts flight_operator.miles_status(malena, 'United') # 6250.0 = 5000 * 1.25
puts flight_operator.miles_status(malena, 'LATAM') # 750.0 = 600 * 1.25

puts flight_operator.buy_flight('LA2', malena) # 400

puts flight_operator.miles_status(malena, 'United') # 6250.0
puts flight_operator.miles_status(malena, 'LATAM') # 4500.0 = 750.0 + 3000 * 1.25

puts flight_operator.buy_flight('LA3', malena) # 0 porque tenía 200 millas

puts flight_operator.miles_status(malena, 'United')  # 6250.0
puts flight_operator.miles_status(malena, 'LATAM') # 4300.0 = 4500.0 - 200.0
class Vehicle
  attr_reader :year

  def initialize(year)
    @year = year
  end

  def start_engine
    'Ready to go!'
  end
end

class Truck < Vehicle
  def initialize(year)
    super(year)
  end

  def start_engine(speed)
    # if you don't need to pass arguments to super, use empty parens!
    super() + " Drive #{speed}, please!"
  end
end

truck1 = Truck.new(1994)
puts truck1.year
puts truck1.start_engine('fast')

class Point
  attr_reader :y_var
  attr_reader :x_var
  def initialize(x_var,y_var)
    @x_var = x_var
    @y_var = y_var
  end
  def distance(other)
    ((@x_var - other.x_var)**2 + (@y_var - other.y_var)**2)**0.5
  end
  def to_s
    "{#{@x_var}, #{@y_var}}"
  end
  def inspect
    to_s
  end

  def hash
    [@x_var, @y_var].hash
  end

  def eql?(other)
    self.==(other)
  end
end

class Figure
  def initialize
    raise 'Cannot initiate an abstract class'
  end
  def perimeter
    raise 'Perimeter method needs to be implemented'
  end
  def area
    raise 'Area method needs to be implemented'
  end
end

class Rectangle < Figure
  def initialize(start_point, end_point)
    @start_point = start_point
    @end_point = end_point
  end
  def perimeter
    (@start_point.x_var - @end_point.x_var).abs*2 + (@start_point.y_var - @end_point.y_var).abs*2
  end
  def area
    (@start_point.x_var.abs - @end_point.x_var.abs)*(@start_point.y_var.abs - @end_point.y_var.abs)
  end
  def to_s
    "[ #{@start_point} , #{@end_point} ]"
  end
end

my_point = Point.new(1.5, 2.5)
puts my_point # Imprime {1.5, 2.5}
puts my_point.distance(Point.new(1.5, 3.0)) # Imprime 0.5

start_point = Point.new(0, 0)
my_rectangle = Rectangle.new(start_point, Point.new(2, 4))
puts my_rectangle
puts my_rectangle.perimeter
puts my_rectangle.area

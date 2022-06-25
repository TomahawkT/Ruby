class Product
  include Comparable
  attr_reader :name, :price
  def initialize(name, price)
    @name = name
    @price = price
  end

  def <=>(other)
    return nil unless other.is_a?(Product)
    c = @name <=> other.name
    c = @price <=> other.price if c.zero?
    c
  end

  def hash
    [@name, @price].hash
  end

  def eql?(other)
    self == other
  end
end

# esto encapsula a los productos con sus cantidades asi no tengo que hacer dos vectores
class Item
  def initialize(product, quantity)
    @product = product
    @quantity = quantity
  end

  def to_s
    "#{@product.name}     #{@quantity}  #{@product.price}\n"
  end

  def get_price
    @product.price * @quantity
  end

  def <=>(other)
    return nil unless other.is_a?(Item)
    @product <=> other.product
  end
end

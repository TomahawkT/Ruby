class MarketBill
  def initialize(catalog)
    raise 'Argument error' unless catalog.is_a? MarketCatalog
    @items = []
    @catalog = catalog
  end
  def add_item( product,  qty)
    raise 'Argument error' unless qty.is_a? Integer
    register_bill_item(product, qty, @catalog.price_for(product, qty))
  end
  def remove_item( product )
    @items.delete(BillItem.new(product))
  end
  protected def register_bill_item( product,  qty, price)
    @items << BillItem.new(product, qty, price)
  end
  def catalog()
    @catalog
  end
  def to_s
    s = ''
    @items.each { |item| s += "#{item}\n" }
    s
  end
end

class BillItem
  attr_reader :product, :qty
  def initialize (product, qty=0, item_total=0.0)
    @product = product
    @qty = qty
    @item_total = item_total
  end
  def to_s
    @product + ' x ' + @qty.to_s + ' = ' + item_total.to_s
  end
  def ==(other)
    return false unless other.is_a? BillItem
    @product == other.product
  end
  def item_total
    @item_total
  end
end


# Catalogo de precios por unidad para cada producto
class MarketCatalog
  def initialize
    @products = Hash.new(0.0)
  end
  def register(product, unit_price)
    @products[product] = unit_price
  end
  def price_for(product, qty)
    @products[product] * qty
  end
end



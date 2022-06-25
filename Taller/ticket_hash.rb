require_relative 'items'
class Ticket
  @@ids = 1000        #con esta variable de clase vamos a poder nombrar a los tickets distinto

  def initialize
    @id = Ticket.get_and_increment
    @items = Hash.new{ 0 }
  end
  def self.get_and_increment
    aux = @@ids
    @@ids += 1
    aux
  end

  def add(product, quantity)
    @items[product] += quantity
  end

  def to_s
    s = "TICKET ##{@id} \n"
    s += "################\n"
    #se podria usar un while, pero usaremos un map
    s+= @items.map{ |item| item.to_s}.reduce("", :+)
    #esto primero hace map: retorna un array de strings (estos strings son los to_s de cada item)
    #luego hace un reduce de este string con la funcion +, entonces convierte al array en 1 string con todos sus eltos sumados
    s += "\n##################\n"
    s += "TOTAL $#{format('%.2f', get_total)}"
  end

  def get_total
    @items.map{|item| item.get_price}.reduce(0, :+)
    #map: crea array de todos los precios de los items, luego el reduce agarra todos estos precios y los suma
  end

end

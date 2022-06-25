class Event
  attr_reader :name
  def initialize(name)
    @name = name
  end
  def to_s
    @name
  end
  def ==(other)
    return nil unless other.is_a?(Event)
    @name == other.name
  end
end

class Ticket
  attr_reader :event, :client
  def initialize(event, client)
    @event = event
    @client = client
  end
  def to_s
    "Ticket < #{@event} | #{@client} >"
  end
  def inspect
    to_s
  end
  def ==(other)
    return nil unless other.is_a?(Ticket)
    @event == other.event && @client == other.client
  end
end

class TicketMaster
  def initialize(event_name)
    @event = Event.new(event_name)
    @tickets = []
  end
  def sell_ticket(client)
    ticket = build_ticket(client)
    @tickets << ticket
    puts "Sold #{ticket}"
  end
  def return_ticket(client)
    ticket = build_ticket(client)
    @tickets.delete(ticket) # delete elimina todas las apariciones del elemento en el array
    puts "Returned #{ticket}"
  end
  def ticket?(client)
    @tickets.include?(build_ticket(client))
  end
  def tickets_count
    @tickets.length
  end
  def sold_tickets
    @tickets
  end
  private
  def build_ticket(client)
    Ticket.new(@event, client)
  end
end

class OnlyOneTicketMaster < TicketMaster
  def initialize(event_name)
    super
    @clients = Array.new
  end
  def sell_ticket(client)
    raise 'Already has a ticket for the event' if ticket?(client)
    super
  end
end

class MaxPeopleTicketMaster < OnlyOneTicketMaster
  attr_reader :pending_clients
  def initialize(event_name, capacity)
    super(event_name)
    @capacity = capacity
    @pending_clients = []
  end

  def sell_ticket(client)
    return super if tickets_count < @capacity
    @pending_clients.push(client) unless @pending_clients.include?(client)
  end

  def return_ticket(client)
    return @pending_clients.delete(client) if @pending_clients.include?(client)
    super
    sell_ticket(poll_first_in_line) unless @pending_clients.empty?
  end
  def poll_first_in_line
    next_client = @pending_clients.first
    @pending_clients.delete(next_client)
    next_client
  end
end


#
# Se instancia un administrador de tickets
#
concert = TicketMaster.new('Concert')
# Se vende un ticket al cliente
concert.sell_ticket('Client 1')
puts '----------'
# Se vende un segundo ticket para el mismo cliente anterior
concert.sell_ticket('Client 1')
puts '----------'
concert.sell_ticket('Client 2')
puts '----------'
# Se imprimen todos los tickets vendidos en orden de venta
puts "Sold: #{concert.sold_tickets}"
puts '----------'
# Se devuelven los dos tickets del cliente
concert.return_ticket('Client 1')
puts '----------'
# Se imprimen todos los tickets vendidos en orden de venta
puts "Sold: #{concert.sold_tickets}"
puts "\n##########\n\n"
#
# Se instancia un administrador de tickets donde se vende solo un ticket por cliente
#
only_one_soccer = OnlyOneTicketMaster.new('Soccer')
# Se vende un ticket al cliente
only_one_soccer.sell_ticket('Client 1')
puts '----------'
begin
  # Falla pues el cliente ya tiene un ticket para el evento
  only_one_soccer.sell_ticket('Client 1')
rescue => e
  puts e.message
end
puts '----------'
only_one_soccer.sell_ticket('Client 2')
puts '----------'
puts "Sold: #{only_one_soccer.sold_tickets}"
puts '----------'
# Se devuelve un ticket del cliente
only_one_soccer.return_ticket('Client 1')
puts '----------'
puts "Sold: #{only_one_soccer.sold_tickets}"
puts "\n##########\n\n"
#
# Se instancia un administrador de tickets donde se vende solo un ticket por cliente # con una cantidad máxima de 2 tickets a vender
#
max_people_art = MaxPeopleTicketMaster.new('Art', 2)
# Se vende un ticket al cliente
max_people_art.sell_ticket('Client 1')
puts '----------'
begin
  # Falla pues el cliente ya tiene un ticket para el evento
  max_people_art.sell_ticket('Client 1')
rescue => e
  puts e.message
end
puts '----------'
max_people_art.sell_ticket('Client 2')
puts '----------'
# Se agregan clientes a la lista de espera pues se alcanzó la cantidad máxima de tickets vendidos
max_people_art.sell_ticket('Client 3')
max_people_art.sell_ticket('Client 4')
max_people_art.sell_ticket('Client 5')
# Si un cliente ya está en la lista de espera no se agrega
max_people_art.sell_ticket('Client 5')
puts '----------'
puts "Sold: #{max_people_art.sold_tickets}"
puts "Pending: #{max_people_art.pending_clients}"
puts '----------'
# Se devuelve un ticket del cliente
# y automáticamente se vende un ticket al primer cliente que estaba en espera
max_people_art.return_ticket('Client 1')
puts '----------'
puts "Sold: #{max_people_art.sold_tickets}"
puts "Pending: #{max_people_art.pending_clients}"
puts '----------'
# Se devuelve el ticket de un cliente que estaba en espera
max_people_art.return_ticket('Client 4')
puts '----------'
max_people_art.return_ticket('Client 2')
puts '----------'
puts "Sold: #{max_people_art.sold_tickets}"
puts "Pending: #{max_people_art.pending_clients}"
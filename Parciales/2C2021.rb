class Event
  def initialize(name, people = 0)
    @name = name
    @people = people
    @active = true
  end
  def deactivate
    @active = false
  end
  def active?
    @active
  end
  def to_s
    @name
  end
  attr_reader :name, :people
end

class ClassroomManager
  def initialize(building_name, default_event)
    @building_name = building_name
    @default_event = default_event
    @rooms = Hash.new
  end
  def book_classroom(room, event)
    @rooms[room].book_event(event)
  end
  def add_classroom(room, capacity)
    raise ArgumentError, 'Classroom already exists' if @rooms.key?(room)
    @rooms[room] = Classroom.new(self, room, capacity)
  end
  def classrooms
    @rooms.values
  end
  def to_s
    @building_name
  end
  attr_reader :default_event
  attr_writer :building_name
end

class Classroom
  include Comparable
  attr_reader :capacity
  def initialize(classroom_manager, room, capacity)
    @classroom_manager = classroom_manager
    @room = room
    @capacity = capacity
    @event = classroom_manager.default_event
  end

  def <=>(other)
    return nil unless other.is_a?(Classroom)
    other.room <=> @room
  end

  def book_event(other)
    raise ArgumentError, 'Cannot book classroom' unless @event.active? && @event == @classroom_manager.default_event
    @event = other
  end
  def to_s
    "Building #{@classroom_manager} # Room #{@room} # #{@event}"
  end

  protected

  attr_reader :room
end

class LimitedClassroomManager < ClassroomManager
  def initialize(building_name, default_event)
    super end
  def book_classroom(room, event)
    raise ArgumentError, 'Cannot book classroom' if event.people >
      @rooms[room].capacity
    super(room, event)
  end
end


#
#  Se instancia un ClassroomManager indicando sede y evento por defecto
#
cm = ClassroomManager.new('Madero', Event.new('No Event'))
# Se agrega el aula '401F' con capacidad para 30 alumnos
cm.add_classroom('401F', 30)
# Se agrega el aula '603F' con capacidad para 40 alumnos
cm.add_classroom('603F', 40)
begin
  # Falla agregar el aula pues ya existe una '401F'
  cm.add_classroom('401F', 20)
rescue ArgumentError => e
  puts e.message
end
puts '-----'
# Se imprime el listado de aulas en orden descendente por nombre de aula
cm.classrooms.sort.each { |classroom| puts classroom }
puts '-----'
# Se reserva el aula '401F' con el evento activo 'Consulta POO'
cm.book_classroom('401F', Event.new('Consulta POO', 50))
puts '-----'
cm.classrooms.sort.each { |classroom| puts classroom }
puts '-----'
# Se cambia el nombre de la sede
cm.building_name = 'SDF'
puts '-----'
cm.classrooms.sort.each { |classroom| puts classroom }
puts '-----'
begin
  # Falla porque ya se reservó el aula '401F' para el evento 'Consulta POO'
  cm.book_classroom('401F', Event.new('Consulta PI', 4))
rescue ArgumentError => e
  puts e.message
end
puts '-----'
event = Event.new('Consulta POD')
event.deactivate
begin# Falla porque el evento que se quiere asignar al aula '603F' está inactivo
  cm.book_classroom('603F', event)
rescue ArgumentError => e
  puts e.message
end
puts '++++++++++'
#
#  Se instancia un LimitedClassroomManager
#  indicando sede y evento por defecto
#
lcm = LimitedClassroomManager.new('Madero', Event.new('Free Classroom'))
lcm.add_classroom('401F', 30)
lcm.add_classroom('603F', 40)
puts '-----'
lcm.classrooms.sort.each { |classroom| puts classroom }
puts '-----'
begin
  # Falla porque la cantidad de asistentes al evento supera la capacidad del aula
  lcm.book_classroom('401F', Event.new('Consulta POO', 31))
rescue ArgumentError => e
  puts e.message
end
lcm.book_classroom('401F', Event.new('Consulta POO', 29))
puts '-----'
lcm.classrooms.sort.each { |classroom| puts classroom }
puts '-----'
begin
  # Falla porque ya se reservó el aula '401F' para el evento 'Consulta POO'
  lcm.book_classroom('401F', Event.new('Consulta PI', 4))
rescue ArgumentError => e
  puts e.message
end
puts '-----'
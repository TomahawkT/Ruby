class UserHashElement
  attr_reader :user, :element
  def initialize(user, element)
    @user = user
    @element = element
  end
end

class UserHash
  def initialize
    @elements = Hash.new
  end
  def store(key, value, user)
    @elements[key] = build_element(value, user)
    puts "User #{user} stored pair #{key} -> #{value}"
  end
  private def build_element(value, user)
    UserHashElement.new(user, value)
  end
  def get(key)
    raise ArgumentError, 'Missing Key' unless @elements.key?(key)
    value = @elements[key]
    puts "Retrieved pair #{key} -> #{value.element} stored by user #{value.user} "
    value.element
  end
  def remove(key)
    @elements.delete(key)
    puts "Deleted key #{key}"
  end
end

class ExpiredUserHash < UserHash
  def initialize(min_requests)
    super()
    @min_requests = min_requests
    @requests_map = Hash.new { 0 }
  end

  private def remove?(key)
    @requests_map[key] >= @min_requests
  end

  def get(key)
    to_return = super
    @requests_map[key] += 1
    remove(key) if remove?(key)
    to_return
  end
end

class SizeExpiredUserHash < ExpiredUserHash
  def initialize(min_requests, max_elems)
    super(min_requests)
    @max_elems = max_elems
  end

  def get(key)
    to_return = super
    @requests_map[key] += 1
    remove(key) if remove?(key)
    to_return
  end
  private def remove?(key)
    super && @elements.size == @max_elems
  end
end



# Un nuevo mapa donde las claves expiren después de 2 consultas
expired_hash = ExpiredUserHash.new(2)
expired_hash.store('Hola', 'Mundo', 'User1')
puts '-----'
p expired_hash.get('Hola')
puts '-----'
expired_hash.store('Hello', 'World', 'User1')
puts '-----'
expired_hash.store('Foo', 'Bar', 'User2')
puts '-----'
# Se elimina la clave pues la cantidad de consultas sobre Hola ahora es 2
p expired_hash.get('Hola')
puts '-----'
begin
  p expired_hash.get('Hola')
rescue ArgumentError => e
  puts e.message
end
puts '#####'
# Un nuevo mapa donde las claves expiren después de 2 consultas # solo si la cantidad de claves presentes es 3
size_expired_hash = SizeExpiredUserHash.new(2,3)
size_expired_hash.store('Hola', 'Mundo', 'User1')
puts '-----'
p size_expired_hash.get('Hola')
puts '-----'
size_expired_hash.store('Hello', 'World', 'User1')
puts '-----'
# No se elimina la clave pues si bien la cantidad de consultas sobre Hola es 2
# la cantidad de claves presentes no es 3
p size_expired_hash.get('Hola')
puts '-----'
size_expired_hash.store('Foo', 'Bar', 'User2')
puts '-----'
# Se elimina la clave pues la cantidad de consultas sobre Hola es mayor a 2
# y la cantidad de claves presentes es 3
p size_expired_hash.get('Hola')
puts '-----'
begin
  p size_expired_hash.get('Hola')
rescue ArgumentError => e
  puts e.message
end

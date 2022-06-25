class ParkingSpace
  def initialize(parking_space)
    @parking_space = parking_space
    @available = true
  end

  def to_s
    "##{@parking_space}: #{@available ? "Available" : "Reserved"}"
  end

  def <=>(other)
    return nil unless other.is_a?(ParkingSpace)
    @parking_space <=> other.parking_space
  end

  def park
    raise 'Cannot Park Reserved Parking Space' unless @available
    @available = false
  end

  def unpark
    raise 'Cannot Unpark Available Parking Space' if @available
    @available = true
  end

  protected

  attr_reader :parking_space

end

class ParkingLot
  def initialize(name)
    @name = name
    @parking_spaces_by_level = Hash.new
  end

  def information
    s = "Parking Lot #{@name}\n"
    @parking_spaces_by_level.keys.sort.each do |level|
      s += "Level #{level}\n"
      @parking_spaces_by_level[level].values.sort.each do |parking_space|
        s += "#{parking_space}\n"
      end
    end
    s
  end

  def add_parking_space(level, parking_space)
    @parking_spaces_by_level[level] = Hash.new unless @parking_spaces_by_level.key?(level)
    @parking_spaces_by_level[level][parking_space] = ParkingSpace.new(parking_space)
  end

  def park(level, parking_space)
    valid_parking_space(level, parking_space)
    @parking_spaces_by_level[level][parking_space].park
  end

  def unpark(level, parking_space)
    valid_parking_space(level, parking_space)
    @parking_spaces_by_level[level][parking_space].unpark
  end

  private def valid_parking_space(level, parking_space)
    raise 'Invalid Level' unless @parking_spaces_by_level.key?(level)
    raise 'Invalid Parking Space' unless @parking_spaces_by_level[level].key?(parking_space)
  end
end









parking_lot = ParkingLot.new('EstacionARTE')
parking_lot.add_parking_space('A', 1030)
parking_lot.add_parking_space('A', 1000)
parking_lot.add_parking_space('A', 1001)
parking_lot.add_parking_space('B', 1001)
puts parking_lot.information
puts '##########'
begin
  parking_lot.park('Z',1001)
rescue RuntimeError => e
  puts e.message
end
puts '##########'
begin
  parking_lot.unpark('A',9999)
rescue RuntimeError => e
  puts e.message
end
puts '##########'
parking_lot.park('A',1001)
parking_lot.unpark('A',1001)
parking_lot.park('A',1001)
begin
  parking_lot.park('A',1001)
rescue RuntimeError => e
  puts e.message
end
puts '##########'
begin
  parking_lot.unpark('B',1001)
rescue RuntimeError => e
  puts e.message
end
puts '##########'
parking_lot.park('B',1001)
puts parking_lot.information

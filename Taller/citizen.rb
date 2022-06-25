class Citizen
  def initialize(dni, first_name, last_name)
    @dni = dni
    @first_name = first_name
    @last_name = last_name
  end

  def inspect
    to_s
  end
  def to_s
    "#{@dni} #{@first_name} #{@last_name}"
  end
end

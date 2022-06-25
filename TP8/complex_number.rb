class ComplexNumber
  attr_reader :real
  attr_reader :imaginary

  def initialize(real, imaginary)
    @real = real
    @imaginary = imaginary
  end
  def +(other)
    ComplexNumber.new(@real+other.real, @imaginary + other.imaginary)
  end
  def to_s
    "#{@real} #{@imaginary.positive? ? "+" : "-"} #{@imaginary.abs}i"
  end

end

first_complex = ComplexNumber.new(2, -1)
second_complex = ComplexNumber.new(3, 0)
res_complex = first_complex + second_complex
puts res_complex.to_s
# Imprime 5 + -1i


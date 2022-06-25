class Counter
  #Combinada
  attr_accessor :count
  def initialize
    @count=0
  end
  def increment
    @count += 1
  end
  def decrement
    @count -= 1
  end
  def to_s
    "#{@count}"
  end
end

class MultipleCounter < Counter
  def initialize(step)
    super()
    @step=step
  end

  def increment
    @count += @step
  end

  def decrement
    @count -= @step
  end
end

puts "Hello World"
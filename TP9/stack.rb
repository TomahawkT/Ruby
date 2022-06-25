class Stack
  def initialize
    @stack = Array.new
  end
  def empty?
    @stack.empty?
  end
  def push(elem)
    @stack.push(elem)
  end
  def pop
    empty_check
    @stack.pop
  end
  def peek
    empty_check
    @stack.last
  end
  private def empty_check
    raise "Stack is empty" if empty?
  end
  def to_s
    @stack.to_s
  end
end

class AccessStack < Stack
  def initialize
    super
    @pop_accesses = 0
  end
  def pop
    to_return = super
    @pop_accesses += 1
    to_return
  end
  def push_accesses
    @stack.size + @pop_accesses
  end
end

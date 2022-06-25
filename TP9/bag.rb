class Bag
  def initialize
    @elements = Hash.new { 0 }
  end
  def add(elem)
    @elements[elem] += 1
  end
  def size
    @elements.length
  end
  def to_s
    @elements.to_s
  end
  def count(elem)
    @elements[elem]
  end
  def delete(elem)
    @elements[elem] -= 1 if @elements.key? elem
    @elements.delete(elem) if @elements[elem].zero?
    @elements[elem]
  end
end

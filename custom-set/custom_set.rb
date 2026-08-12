# We could inherit from Array or from Set but let's see what it looks like when it's all implemented without inheritance
class CustomSet

  def initialize(array)
    @contents = array.uniq
  end

  def empty?
    @contents.empty?
  end

  def member?(element)
    @contents.include?( element )
  end

  def subset?(other)
    @contents.all? { |element| other.member?(element) }
  end

  def disjoint?(other)
    @contents.none? { |element| other.member?(element) }
  end

  def add(element)
    @contents << element unless @contents.include?(element)
    self
  end

  def intersection(other)
    CustomSet.new(@contents.select { |element| other.member?(element) })
  end

  def difference(other)
    CustomSet.new(@contents.select { |element| !other.member?(element) })
  end

  def union(other)
    CustomSet.new (@contents + other.to_a).uniq
  end

  # We could have made this an attr_reader and protected - but it is generally useful to expose conversion to array
  def to_a
    @contents.dup
  end

  def ==(other)
    super || (
      self.class == other.class &&
      @contents.sort == other.to_a.sort
    )
  end
  alias_method :eql?, :==

  # required for has key usage which we don't use at the moment
  def hash
    @contents.to_h
  end

  # required for comparable / sorting which again we don't use at the moment
  def <=>(other)
    @contents <=> other.to_a
  end
end

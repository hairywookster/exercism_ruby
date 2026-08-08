class ComplexNumber
  attr_reader :real, :imaginary

  def initialize(real, imaginary = 0)
    @real = real
    @imaginary = imaginary
  end

  def *(other)
    ComplexNumber.new( (@real * other.real) - (@imaginary * other.imaginary), (@real * other.imaginary) + (@imaginary * other.real) )
  end

  def +(other)
    ComplexNumber.new(@real + other.real, @imaginary + other.imaginary)
  end

  def -(other)
    ComplexNumber.new(@real - other.real, @imaginary - other.imaginary)
  end

  def conjugate
    ComplexNumber.new(@real, -@imaginary)
  end

  def exp
    # Alternative is ComplexNumber.new(Math.exp(@real)) * ComplexNumber.new(Math.cos(@imaginary), Math.sin(@imaginary))
    # FYI - I had to look this bit up as the Exponentiation formula on the exercise page is missing the line that gets you here
    # And - I'm a programmer not a maths geek (say it in Star Trek's Doctor Mcoy's voice...)
    ComplexNumber.new(Math.exp(@real) * Math.cos(@imaginary), Math.exp(@real) * Math.sin(@imaginary))
  end

  def /(other)
    denominator = (other.real**2) + (other.imaginary**2)
    ComplexNumber.new( ((@real * other.real) + (@imaginary * other.imaginary)).to_f / denominator, ((@imaginary * other.real) - (@real * other.imaginary)).to_f / denominator )
  end

  def abs
    Math.sqrt(@real**2 + @imaginary**2)
  end

  # Handle Equality part 1
  def ==(other)
    self.class == other.class &&
      approximately_equal?(real, other.real) &&
      approximately_equal?(imaginary, other.imaginary)
  end

  def approximately_equal?(val1, val2, epsilon = 1e-10)
    (val1 - val2).abs < epsilon
  end

  # Handle Equality part 2
  def ===(other)
    self == other
  end

  # Handle Equality part 3
  def eql?(other)
    self == other
  end

  # Handle Equality part 4
  def hash
    [@real, @imaginary].hash
  end

  def to_s
    "#{@real} + #{@imaginary}i"
  end

end

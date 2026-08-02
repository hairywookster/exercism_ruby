class CircularBuffer
  class BufferEmptyException < StandardError ; end
  class BufferFullException < StandardError ; end

  def initialize(max_size)
    @max_size = max_size
    @contents = []
  end

  def read
    raise CircularBuffer::BufferEmptyException if @contents.empty?

    @contents.pop
  end

  def clear
    @contents.clear
  end

  def write(value)
    raise CircularBuffer::BufferFullException if @contents.size == @max_size

    @contents.unshift(value)
  end

  def write!(value)
    @contents.pop if @contents.size == @max_size
    write(value)
  end

end

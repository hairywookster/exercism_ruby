class BinarySearch

  def initialize(array)
    @array = array
  end

  def search_for(value)
    # nothing to search in
    return nil if @array.empty?

    # These are not strictly required, the algo below works without them, but they reduce expense for simplest cases.
    # we have only one item so it is just a basic equality comparison only
    return 0 if @array.size == 1 && @array[0] == value
    # the value is less than the first element so no point searching
    # the value is greater than the last element so no point searching
    return nil if value < @array.first || value > @array.last

    # set left pos as first element and last pos as last element
    left_pos = 0
    max_array_index = @array.size - 1
    right_pos = max_array_index

    # We will repeat the process below until the left_pos or right_pos has passed each other
    while left_pos <= right_pos
      mid_pos = (left_pos + right_pos) / 2

      value_at_mid_pos = @array[mid_pos]
      # if the mid_pos value is the value were looking for return the mid_pos as the index location
      return mid_pos if value_at_mid_pos == value
      # if the mid_pos has reached the start or end indexes, and we did not find the value exit early
      return nil if mid_pos.zero? || mid_pos == max_array_index

      if value > value_at_mid_pos
        # we need to check the right side only so move left_pos to current mid point(+1)
        left_pos = mid_pos + 1
      else
        # we need to check the left side only so move right_pos to current mid point(-1)
        right_pos = mid_pos - 1
      end

    end
    nil
  end
end

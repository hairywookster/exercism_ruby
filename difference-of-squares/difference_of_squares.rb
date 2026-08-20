class Squares

  def initialize( limit )
    @limit = limit
  end

  def square_of_sum
    #(1..@limit).sum**2                               # normal ruby O(n)
    (@limit * (@limit + 1) / 2) ** 2                  # maths hack care of Pythagoras of Samos  O(1)
  end

  def sum_of_squares
    #(1..@limit).sum { |x| x**2 }                      # normal ruby O(n)
    (@limit * (@limit + 1) * (2 * @limit + 1)) / 6     # maths hack care of Pythagoras of Samos  O(1)
  end

  def difference
    square_of_sum - sum_of_squares
  end
end

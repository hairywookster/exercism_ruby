require 'matrix'

class Darts
  attr_reader :score

  INNER_CIRCLE_RADIUS = 1
  MIDDLE_CIRCLE_RADIUS = 5
  OUTER_CIRCLE_RADIUS = 10

  def initialize(x_pos, y_pos)
    # Were really just determining the length of the longest side of the triangle(hypotenuse) ala Pythagorean theorem
    # Then we know how far the arrow is from the center w.r.t. which circle's radius it fits within...
    #
    # If we wanted to do this math ourselves it would be
    # vector_length = Math.sqrt(x**2 + y**2)
    # But there are additional optimizations that can provide faster approx answer depending on requirements.
    @score = calculate_score(Vector[x_pos, y_pos].magnitude)
  end

  private def calculate_score(vector_length)
    if vector_length <= INNER_CIRCLE_RADIUS
      10
    elsif vector_length <= MIDDLE_CIRCLE_RADIUS
      5
    elsif vector_length <= OUTER_CIRCLE_RADIUS
      1
    else
      0
    end
  end

end

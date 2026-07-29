class Game

  class BowlingError < StandardError; end

  class Frame
    attr_reader :pins
    def initialize(pins)
      @pins = pins
    end
  end

  class Strike < Frame
    def score(next_frame, next_again_frame, _)
      if next_frame.is_a?(Strike)
        10 + 10 + next_again_frame.pins[0]
      else
        10 + next_frame.pins[0..1].sum
      end
    end
  end

  class Open < Frame
    def score(_, _, _)
      @pins.sum
    end
  end

  class Spare < Frame
    def score(next_frame, _, _)
      @pins.sum + next_frame.pins[0]
    end
  end

  class Tenth < Frame
    def score(_, _, current_frame_index)
      if current_frame_index == 9
        raise BowlingError if @pins.size == 1 && @pins[0] == 10
        raise BowlingError if @pins.size == 2 && @pins[0] == 10 && @pins[1] == 10
        raise BowlingError if @pins.size == 2 && @pins.sum == 10

        @pins.sum # scoring ourself
      else
        @pins[0] + @pins[1] # scoring call from ninth only
      end
    end

    def complete?
      return true if @pins.size == 3
      return true if @pins.size == 2 && @pins.sum < 10

      false
    end

    def update_pins(pins)
      @pins = pins
    end
  end

  def initialize
    @frames = []
    @current_pins = []
  end

  def roll(pins_knocked_over)
    raise BowlingError unless pins_knocked_over >= 0
    raise BowlingError if pins_knocked_over > 10
    raise BowlingError if @frames.size == 10 && @frames.last.complete?

    @current_pins << pins_knocked_over
    if @frames.size >= 9
      handle_tenth_frame_rules_for_roll
    else
      handle_general_rules_for_roll
    end
  end

  def handle_tenth_frame_rules_for_roll
    raise BowlingError if @current_pins.size == 3 &&
                          @current_pins[0] == 10 &&
                          @current_pins[1] != 10 &&
                          @current_pins[1..2].sum > 10

    @frames << Tenth.new(@current_pins) if @frames.size < 10
    @frames.last.update_pins(@current_pins)
  end

  def handle_general_rules_for_roll
    raise BowlingError if @current_pins.sum > 10

    if @current_pins.size == 1 && @current_pins[0] == 10
      @frames << Strike.new(@current_pins)
      rack_pins
    elsif @current_pins.size == 2 && @current_pins.sum == 10
      @frames << Spare.new(@current_pins)
      rack_pins
    elsif @current_pins.size == 2 && @current_pins.sum < 10
      @frames << Open.new(@current_pins)
      rack_pins
    end
  end

  def score
    raise BowlingError if @frames.empty? || @frames.size < 10

    total_score = 0
    @frames.each_with_index do |frame, index|
      next_frame = @frames[index+1]
      next_again_frame = @frames[index+2]
      total_score += frame.score(next_frame, next_again_frame, index)
    end
    total_score
  end

  def rack_pins
    @current_pins = []
  end

end

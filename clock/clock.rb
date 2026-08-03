class Clock
  attr_reader :hours, :minutes

  def initialize(hour: 0, minute: 0)
    calc_time(hour, minute)
  end

  def to_s
    "#{hours_display}:#{minutes_display}"
  end

  # we return a new instance since were not using a bang style method
  def +(other)
    Clock.new(hour: @hours + other.hours, minute: @minutes + other.minutes)
  end

  def -(other)
    Clock.new(hour: @hours - other.hours, minute: @minutes - other.minutes)
  end

  def ==(other)
    super || to_s.eql?(other.to_s)
  end

  private

  def calc_time(hour, minute)
    @hours = (hour + (minute / 60)) % 24
    @minutes = minute % 60
  end

  def hours_display
    @hours.to_s.rjust(2, '0')
  end

  def minutes_display
    @minutes.to_s.rjust(2, '0')
  end

end


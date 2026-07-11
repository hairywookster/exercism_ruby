class AssemblyLine
  NUMBER_OF_CARS_PRODUCED_PER_HOUR = 221
  MINUTES_PER_HOUR = 60

  def initialize(speed)
    @speed = speed
  end

  def production_rate_per_hour
    @speed * NUMBER_OF_CARS_PRODUCED_PER_HOUR * success_rate
  end

  def working_items_per_minute
    (production_rate_per_hour / MINUTES_PER_HOUR).floor
  end

  def success_rate
    return 1.0 if @speed <= 4
    return 0.9 if @speed <= 8
    return 0.8 if @speed == 9
    return 0.77 if @speed == 10

    nil
  end
end

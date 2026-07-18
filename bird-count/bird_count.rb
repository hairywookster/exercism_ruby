class BirdCount
  BUSY_DAY_THRESHOLD = 5

  @@last_weeks_counts = [0, 2, 5, 3, 7, 8, 4]

  def self.last_week
    @@last_weeks_counts
  end

  def initialize(birds_per_day)
    @birds_per_day = birds_per_day
  end

  def yesterday
    @birds_per_day[-2]
  end

  def total
    @birds_per_day.sum
  end

  def busy_days
    @birds_per_day.count { |count| count >= BUSY_DAY_THRESHOLD }
  end

  def day_without_birds?
    @birds_per_day.any? { |count| count.zero? }
  end

end

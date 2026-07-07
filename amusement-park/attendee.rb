class Attendee
  attr_reader :pass_id

  def initialize(height_in_centimeters)
    @height_in_centimeters = height_in_centimeters
    @pass_id = nil
  end

  def height
    @height_in_centimeters
  end

  def issue_pass!(pass_id)
    @pass_id = pass_id
  end

  def revoke_pass!
    @pass_id = nil
  end
end

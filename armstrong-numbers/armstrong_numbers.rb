module ArmstrongNumbers

  def self.include?(number)
    digits = number.digits
    digits.sum { |x| x.to_i**digits.length } == number
  end

end

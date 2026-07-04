module BaseConverter

  # Normally we would just use the .to_s(base_number) to convert to a specific base
  # but the exercise wanted it done without using the built-ins

  def self.convert(input_base, digits, output_base)
    raise ArgumentError if input_base <= 1
    raise ArgumentError if output_base <= 1
    raise ArgumentError if digits.any?(&:negative?)
    raise ArgumentError if digits.any? { |x| x >= input_base }

    as_base10 = convert_to_base10(input_base, digits)
    convert_to_base(output_base, as_base10)
  end

  private_class_method def self.convert_to_base10(input_base, digits)
    # a more succinct version is
    # digits.reverse.map.with_index {|value, index| value * (input_base ** index) }.sum
    total = 0
    digits.reverse.each_with_index do |value, index|
      total += value * input_base**index
    end
    total
  end

  private_class_method def self.convert_to_base(output_base, value)
    # defensive if the value is zero just return array with zero
    return [0] if value.zero?

    # otherwise collect the remainder of each division by the base,
    # then reverse what we collected to get the answer
    values = []
    while value.positive?
      #puts "value=#{value}"
      values << value % output_base
      value /= output_base
      #puts "  values=#{values} value=#{value}"
    end
    values.reverse
  end

end

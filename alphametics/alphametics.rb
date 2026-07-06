module Alphametics

  def self.solve(puzzle)
    return {} unless initial_data_sane?(puzzle)

    unique_letters = puzzle.scan(/[A-Z]/).uniq
    unique_leading_letters = puzzle.scan(/\b[A-Z]/).uniq
    leading_letter_indices = (0...unique_leading_letters.size).to_a
    ordered_letters = unique_leading_letters + (unique_letters - unique_leading_letters)
    numbers = (0..9).to_a
    #puts "Unique letters=#{unique_letters}"
    #puts "Unique leading letters=#{unique_leading_letters}"
    #puts "Leading letter indices=#{leading_letter_indices}"
    #puts "Ordered letters=#{ordered_letters}"
    #puts "Numbers=#{numbers}"

    ordered_weights = determine_weights(puzzle, ordered_letters)

    # Now we test each permutation until we find the solution
    numbers.permutation(ordered_letters.size).each do |permutation|
      # skip if the permutation breaks the leading zero constraint
      next if leading_letter_indices.any? { |i| permutation[i].zero? }

      # Strategy 1 - took around 54 seconds to process the tests
      #letters_to_digits_mapping = ordered_letters.zip(permutation).to_h
      #puts "Permutation Letters to digits=#{letters_to_digits_mapping}"
      #return letters_to_digits_mapping if solved?(puzzle, letters_to_digits_mapping)

      # Strategy 2 - takes around 3 seconds to process the tests - much faster
      # The maths for strategy 2 does not require eval / string generation / hash generation
      return ordered_letters.zip(permutation).to_h if sum_solved?(ordered_weights, permutation)
    end

    # There is no solution to this problem because the Alphametic puzzle is invalid
    {}
  end

  # totals up the sum of the ordered_weights multiplied by the permutations numbers.
  # Essentially a fast/efficient dot product (multiplying weights by the mapped digits)
  private_class_method def self.sum_solved?(ordered_weights, permutation)
    sum = 0
    # the .each_with_index is around 2 seconds slower than the while, increases time taken by around 40%
    #ordered_weights.each_with_index do |weight, i|
    #  sum += weight * permutation[i]
    #end
    i = 0
    while i < ordered_weights.size
      # When the ordered weight is negative it acts as a subtraction - reducing the sum towards 0.
      sum += ordered_weights[i] * permutation[i]
      i += 1
    end
    # if the sum == 0 we are solved, otherwise the permutation did not compute
    sum.zero?
  end

  # Map weight of letters based on placement and decimal system
  #
  # SEND is equivalent to
  #   (1000 * S) + (100 * E) + (10 * N) + (1 * D)
  # MORE is equivalent to
  #   (1000 * M) + (100 * O) + (10 * R) + (1 * E)
  #
  # The word on the right can be moved to the left by subtracting it from both sides
  #   SEND + MORE - MONEY = MONEY - MONEY
  #   SEND + MORE - MONEY = 0
  #
  # MONEY now becomes  (Left side additions add weight, right side subtracts weight)
  # (-10000 * M) + (-1000 * O) + (-100 * N) + (-10 * E) + (-1 * Y)
  #
  # Now we can reduce the summation from an expensive eval + string + hash object creation to a simple
  #
  # Any sum that equals zero at the end is solved.
  private_class_method def self.determine_weights(puzzle, ordered_letters)
    # determine all words on left and right
    left, right = puzzle.split('==').map(&:strip)
    left_words = left.split(' + ')
    right_word = right

    # add weights
    weights = Hash.new(0)
    # left words have positive values
    left_words.each { |word| add_weights(word, weights, 1) }
    # right words have negative values (since we moved them to the left they flip from positive to negative)
    add_weights(right_word, weights, -1)

    # Reorder the weights so they match the order of the letters for use in our summation
    ordered_letters.map { |char| weights[char] }
  end

  # Set each character encountered to a positive or negative weighted equivalent
  private_class_method def self.add_weights(word, weights, multiplier)
    word.reverse.each_char.with_index do |char, index|
      # the weight increases or decreases(if negative multiplier) depending on the previous usages
      # of the letter and which side of the sum it was used on.
      weights[char] += (10**index) * multiplier
    end
  end

  private_class_method def self.initial_data_sane?(puzzle)
    # Defensive return empty mapping for these cases where there is no work
    return false if puzzle.nil?
    return false if puzzle.empty?
    return false unless puzzle.include?('==')

    # defend against no letters
    unique_letters = puzzle.scan(/[A-Z]/).uniq
    return false if unique_letters.empty?

    # defend against too many letters - we only have 10 digits 0-9
    return false if unique_letters.size > 10

    # defend against left and right having a single letter
    left, right = puzzle.split('==').map(&:strip)
    return false if left.size == 1 && right.size == 1

    # defend against right having more than one word (in theory we could allow this but the tests do not ask for it)
    return false if right.include?(' ')

    # defend against left side having larger numbers than right side
    left_max = left.split(' + ').max_by(&:length).length
    right_max = right.split(' + ').max_by(&:length).length
    return false if left_max > right_max

    true
  end

  # returns true if the left side summation matches the right side total, otherwise false
  # private_class_method def self.solved?(puzzle, letters_to_digits_mapping)
  #   #puts "----------------------------------------------------------"
  #   #puts "Permutation Letters to digits=#{letters_to_digits_mapping}"
  #   #puts "Letters -> #{letters_to_digits_mapping.keys.join}"
  #   #puts "Numbers -> #{letters_to_digits_mapping.values.join}"
  #   math_replaced = puzzle.tr(letters_to_digits_mapping.keys.join, letters_to_digits_mapping.values.join)
  #   #puts "Math -> #{math_replaced}"
  #   eval(math_replaced)
  # end

end

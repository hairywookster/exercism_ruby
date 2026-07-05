class Allergies

  # Second simpler approach uses bit position as the allergy counts shadow bit positions
  # i.e. 00000001 - allergic to cats  
  # i.e. 00000011  - allergic to peanuts and cats

  # listed in order of bit position lowest to highest
  ALLERGY_ARRAY = %i[eggs peanuts shellfish strawberries tomatoes chocolate pollen cats].freeze

  def initialize(allergy_count)
    # convert the number to binary (bits) ,
    # reverse the resulting string
    # map each 1 or 0 to the ALLERGY_ARRAY - the index of the character maps to the allergies index
    # 1 - means allergic to this allergy, 0 means not.
    # Ignore any allergy bit that falls outwith the size of the ALLERGY_ARRAY
    # apply compact to remove the nils
    @allergies = allergy_count.to_s(2).reverse.each_char.with_index.map do |x, index|
      if x == '0'
        nil
      else
        index <= ALLERGY_ARRAY.size - 1 ? ALLERGY_ARRAY[index].to_s : nil
      end
    end.compact
  end

  def allergic_to?(item_name)
    return false if @allergies.empty?

    @allergies.include?(item_name)
  end

  def list
    @allergies
  end

  

  # First strategy did this without using bits but is clunky...
  #
  # # Note if we add new allergies in here, maintaining the order, everything just works,
  # # so long as the allergy follows the doubling up pattern
  # ALLERGY_ITEMS = {
  #   cats: 128,
  #   pollen: 64,
  #   chocolate: 32,
  #   tomatoes: 16,
  #   strawberries: 8,
  #   shellfish: 4,
  #   peanuts: 2,
  #   eggs: 1
  # }.freeze
  #
  # # Calculate the maximum sum of all the known allergies (128 + 64 + 32 + 16 + 8 + 4 + 2 + 1) or whatever is in the ALLERGY_ITEMS
  # MAX_ALLERGY_TOTAL = ALLERGY_ITEMS.values.sum
  #
  # def initialize(allergy_count)
  #   @allergy_count = apply_allergy_bounds(allergy_count)
  # end
  #
  # def allergic_to?(item_name)
  #   return false if @allergy_count.zero?
  #
  #   collect_allergies.include?(item_name)
  # end
  #
  # # The output wants the allergies from smallest to largest - shrug :)
  # def list
  #   collect_allergies.reverse
  # end
  #
  # private
  #
  # def apply_allergy_bounds(allergy_count)
  #   return 0 if allergy_count.negative? || allergy_count.zero?
  #   return allergy_count if allergy_count <= MAX_ALLERGY_TOTAL
  #
  #   # We know every allergy that is not listed follows the doubling pattern i.e. 256 -> 512 -> 1024 -> ...
  #   # We need to bring our allergy_count down to at most (128 + 64 + 32 ... + 1)
  #   # So find the highest doubled up number that would not fit into the current allergy_count
  #   highest_doubled_value = ALLERGY_ITEMS.values.max
  #   highest_doubled_value *= 2 while highest_doubled_value < allergy_count
  #
  #   # Now divide that number by 2
  #   # Then subtract from the allergy_count
  #   # and divide the remaining number by 2 until the allergy count is in bounds (less than MAX_ALLERGY_TOTAL)
  #   highest_doubled_value /= 2
  #   while allergy_count > MAX_ALLERGY_TOTAL
  #     allergy_count -= highest_doubled_value
  #     highest_doubled_value /= 2
  #   end
  #   allergy_count
  # end
  #
  # # Now we employ a greedy algorithm
  # # We attempt to consume the allergy_count by stepping through each of the known allergies
  # # from highest to lowest, and if an allergy score fits we note the allergy and remove the allergies score from the
  # # allergy_count - we repeat this until the allergy_score reaches zero, or we run out of allergies.
  # def collect_allergies
  #   allergies = []
  #   temp_allergy_count = @allergy_count
  #   ALLERGY_ITEMS.each do |allergy_item_name, score|
  #     if temp_allergy_count >= score
  #       temp_allergy_count -= score
  #       allergies << allergy_item_name.to_s
  #     end
  #     break if temp_allergy_count.zero?
  #   end
  #   allergies
  # end

end

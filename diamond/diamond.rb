module Diamond

  ALPHABET = ('A'..'Z').to_a.freeze

  def self.make_diamond(character)
    num_chars = ALPHABET.find_index(character) + 1
    # 1 -> 1,  2 -> 3,  3 -> 5,  5 -> 9
    num_cols = num_chars * 2 - 1
    # midpoint of column is at num chars index i.e. 1 char - 0, 2 char - 1, etc
    left_idx = num_chars - 1
    right_idx = num_chars - 1
    left_dir = -1  # go further left
    right_dir = 1  # go further right
    char_index = 0
    char_dir = 1   # go further down
    output = []

    num_cols.times do
      #create a blank row
      current_row = ' ' * num_cols

      # add current character to left and right idx locations
      current_row[left_idx] = ALPHABET[char_index]
      current_row[right_idx] = ALPHABET[char_index] if left_idx != right_idx   # avoid overwrite on first/last rows
      output << current_row
      # The tests want a newline after each row irrespective of whether it is the last row
      output << "\n"

      # If indexes have reached start/end of columns - flip direction of travel
      if left_idx == 0
        left_dir = -left_dir
        right_dir = -right_dir
        char_dir = -char_dir
      end
      # Set next positions and next character
      left_idx += left_dir
      right_idx += right_dir
      char_index += char_dir
    end

    # NB An alternative strategy involves building only the first half of the diamond and then
    # duplicating the previously built rows for the remainder
    # we would break at   if left_idx == 0 and add code below to dup the pre-built rows

    output.join
  end

end

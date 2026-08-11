class Crypto

  def initialize(plaintext)
    @plaintext = plaintext.downcase.gsub(/[^a-z0-9]/, '')
  end

  def ciphertext
    return '' if @plaintext.empty?
    return @plaintext if @plaintext.length == 1

    generate_for_columns( calculate_columns(@plaintext.length) )
  end

  private

  # take square root of text length - gives us an exact int or a float then round to next highest integer
  # sqrt(16) = 4 -> 4 cols/4 rows
  # sqrt(11) = 3.31... ->  round to 4 ->  4 cols, 3 rows  (last row will have a space at the end)
  def calculate_columns(text_length)
    Math.sqrt(text_length).ceil
  end

  # cut the text into slices of column size
  # we may end up with the last slice having less chars than the first slice !
  # iterate over each column to build the row
  # each row is essentially the character from column x in each of the slices
  # Note the ruby array transpose method could do almost all of this for us but let's do our own for fun!
  def generate_for_columns(columns)
    sliced_characters = @plaintext.chars.each_slice(columns).to_a

    encoded = (0...columns).map do |column|
      row = ''.dup
      sliced_characters.each do |char_array|
        # this adds a space if the slice has fewer chars than columns we reference
        row << (char_array[column].nil? ? ' ' : char_array[column])
      end
      row
    end
    encoded.join(' ')
  end

end

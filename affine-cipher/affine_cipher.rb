class Affine

  ALPHABET = ('a'..'z').to_a
  ALPHABET_LENGTH = ALPHABET.length

  def initialize(key1, key2)
    # This could perhaps be optimized by pre-computing the ~12 coprime numbers below 26
    raise ArgumentError unless key1.gcd(ALPHABET_LENGTH) == 1

    @key1 = key1
    @key2 = key2
    # Were computing what each character will be replaced with so that we can both encode or decode efficiently.
    # This provides us with a reusable 1 to 1 mapping for each character.
    # This also has the benefit of allowing us to more quickly encode/decode efficiently with the current keys
    # Especially useful if your encoding/decoding multiple messages or very long messages (each char calculated once only)
    @encoded_alphabet = ALPHABET.map.with_index { |_, index| ALPHABET[((@key1 * index) + @key2) % ALPHABET_LENGTH] }.join
  end

  def encode(plaintext)
    # Strip all non word characters like spaces and commas etc.
    # Transpose each letter in the alphabet for its encoded value where located in the plaintext,
    # then chunk into at most 5 chars separated by a space.
    plaintext.downcase.gsub(/\W/, '').tr(ALPHABET.join, @encoded_alphabet).scan(/.{1,5}/).join(' ')
  end

  def decode(ciphertext)
    # Strip all non word characters like spaces and commas etc.
    # Transpose each encoded letter for its original letter via the reverse of the encode operation
    # We can thus forget about the whole modular multiplicative inverse (mmi) and related math
    ciphertext.downcase.gsub(/\W/, '').tr(@encoded_alphabet, ALPHABET.join)
  end


  # FYI - gcd - greatest common divisor algorithm
  #
  # starting with for example
  # call 1 -  gcd(5,6)
  # call 2 -  gcd(5,1)
  # call 3 -  gcd(4,1)
  # call 4 -  gcd(3,1)
  # call 5 -  gcd(2,1)
  # call 6 -  gcd(1,1) - returns  1  - co-prime
  # starting with for example
  # call 1 -  gcd(8,16)
  # call 2 -  gcd(8,8) - returns  8  - not co-prime
  #
  # def gcd(a, b)
  #   # Everything divides 0 so not co-prime
  #   return 0 if a.zero? || b.zero?
  #
  #   # a=1,b=1 is co-prime , a != 1   it's not co-prime
  #   return a if a == b
  #
  #   return gcd(a-b, b) if a > b
  #   return gcd(a, b-a);
  # end

  # FYI - MMI -  modular multiplicative inverse
  # Find the first number where (key1 * n) % ALPHABET.length == 1
  #
  # def mmi(a)
  #   (0..(ALPHABET.length-1)).each do |x|
  #     return x if (a * x) % ALPHABET.length == 1
  #   end

end

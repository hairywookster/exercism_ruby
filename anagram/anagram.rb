class Anagram

  def initialize(word)
    # first is redundant in the simple/fast implementation
    #@word = word
    @word_downcased = word.downcase
    @word_sorted_downcased = @word_downcased.chars.sort.join
  end

  def match(words)
    # Naive implementation
    # get every permutation of the word, downcase each permutation, convert to hash for quick lookup
    # Without a hash we would be iterating through entire permutations list multiple times via - permutations_of_word_downcased.any? { |permutation| permutation == word_to_find_downcased }
    # permutations_of_word_downcased = @word.chars.permutation(@word.length).map {|x| x.join.downcase }.to_h { |perm| [perm, 0] }
    # words.select do |word_to_find|
    #   word_to_find_downcased = word_to_find.downcase
    #   word_to_find_downcased != @word_downcased && permutations_of_word_downcased.key?(word_to_find_downcased)
    # end

    # Simple/Fast implementation taking into account re-ordering of letters in the words
    words.select do |word_to_find|
      word_to_find_downcased = word_to_find.downcase
      # check least to most expensive check for better performance
      @word_downcased.length == word_to_find_downcased.length && @word_downcased != word_to_find_downcased && word_to_find_downcased.chars.sort.join == @word_sorted_downcased
    end
  end

end

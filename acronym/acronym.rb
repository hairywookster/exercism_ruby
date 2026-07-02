module Acronym

  def self.abbreviate(sentence)
    # splitting by just   \b\w   (any word boundary   and   any non-word-character   works for most but not all)

    # this works buts is fugly
    #sentence.gsub('-', ' ').split(/\s/).collect { |x| x.gsub(/[^a-zA-Z]/, '')[0] }.join.upcase

    # strip out any obvious crud that interferes with our word boundaries,
    # then scan for a boundary followed by a letter, join the letters as an array and upcase the result
    sentence.gsub(/[_']/, '').scan(/\b[a-zA-Z]/).join.upcase
  end

end

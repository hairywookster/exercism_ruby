module Atbash

  A_TO_Z = ('a'..'z').to_a.join.freeze
  Z_TO_A = A_TO_Z.reverse.freeze

  def self.encode(plaintext)
    plaintext.gsub(/[\s|\W]/, '').downcase.tr(A_TO_Z, Z_TO_A).scan(/.{1,5}/).join(' ')
  end

  def self.decode(ciphertext)
    ciphertext.gsub(' ', '').tr(Z_TO_A, A_TO_Z)
  end

end

module Blackjack

  def self.create_card_values
    h = {
      ace: 11,
      two: 2,
      three: 3,
      four:	4,
      five:	5,
      six:	6,
      seven: 7,
      eight: 8,
      nine:	9,
      ten: 10,
      jack:	10,
      queen: 10,
      king:	10
    }
    h.default = 0
    h.freeze
    h
  end

  private_class_method :create_card_values

  CARD_VALUES = create_card_values

  VALUE_RANGES = {
    low: 4..11,
    mid: 12..16,
    high: 17..20,
    blackjack: 21..21
  }.freeze

  STAND = 'S'.freeze
  SPLIT = 'P'.freeze
  HIT = 'H'.freeze
  WIN = 'W'.freeze

  ACE = "ace".freeze
  ACE_VALUE = 11.freeze

  MINIMUM_VALUE_TO_HIT = 7.freeze


  def self.parse_card(card)
    CARD_VALUES[card.to_sym]
  end

  def self.card_range(card1, card2)
    total = card_totals(card1, card2)
    VALUE_RANGES.select { |label, range| range.include?(total) }.keys[0].to_s
  end

  def self.card_totals(card1, card2)
    parse_card(card1) + parse_card(card2)
  end

  def self.first_turn(card1, card2, dealer_card)
    return SPLIT if ACE == card1 && ACE == card2

    card_range = card_range(card1, card2).to_sym
    dealer_card_value = parse_card(dealer_card)
    return WIN if card_range == :blackjack && dealer_card_value != ACE_VALUE
    return STAND if card_range == :blackjack && dealer_card_value == ACE_VALUE

    return STAND if card_range == :high
    return STAND if card_range == :mid && dealer_card_value < MINIMUM_VALUE_TO_HIT
    return HIT if card_range == :mid && dealer_card_value >= MINIMUM_VALUE_TO_HIT

    # we do not need to implement the following rules since final action can only be HIT
    #card_totals = card_totals(card1, card2)
    #return HIT if card_totals <= 11
    return HIT
  end

end

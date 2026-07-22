module BottleSong

  # Normally we would bind in a gem to do conversion of numbers to words such as numbers_and_words or humanize
  BOTTLES_AS_WORD = %w[no One Two Three Four Five Six Seven Eight Nine Ten].freeze

  def self.recite(bottles, iterations)
    messages = []
    bottles_processed = 0

    # We will start at the number of bottles and build a verse for each requested iteration
    bottles.downto((bottles - iterations) + 1) do |num_bottles|
      bottles_processed += 1
      messages << build_verse(num_bottles, bottles_processed >= iterations)
    end
    messages.join
  end

  # We create a separate method to deal with the verse creation
  def self.build_verse(num_bottles, last_block)
    <<~TEXT
#{BOTTLES_AS_WORD[num_bottles]} green #{plural(num_bottles)} hanging on the wall,
#{BOTTLES_AS_WORD[num_bottles]} green #{plural(num_bottles)} hanging on the wall,
And if one green bottle should accidentally fall,
There'll be #{BOTTLES_AS_WORD[num_bottles-1].downcase} green #{plural(num_bottles-1)} hanging on the wall.#{last_block ? '' : "\n"}
    TEXT
  end

  # We create a separate method to deal with the pluralization
  # Normally we would bind in a gem like active support's ActiveSupport::Inflector to do this pluralization work for us via .pluralize
  def self.plural(num_bottles)
    num_bottles != 1 ? 'bottles' : 'bottle'
  end

  private_class_method :build_verse, :plural

end

module BookStore

  UNDISCOUNTED_BOOK_PRICE = 8.00
  DISCOUNTS_PER_NUM_BOOKS = [0, 0, 5, 10, 20, 25].freeze
  MAX_BUNDLE_SIZE = 5
  MIN_BUNDLE_SIZE = 2

  def self.calculate_price(basket)
    # We have an empty basket so no cost
    return 0.0 if basket.empty?

    # The next two lines are not strictly required, commenting them out everything still works,
    # but it provides an efficient bug out for the simplest/ most frequent cases
    # i.e. in a real system you likely have a huge percent more single book purchases than multi book purchases...
    cost = calculate_book_bundle_price(basket)
    return cost unless cost.negative?

    # at this point we must calculate the lowest cost based on grouping books
    calculate_grouped_price(basket)
  end

  def self.calculate_discount(num_books)
    1.0 - (DISCOUNTS_PER_NUM_BOOKS[num_books] / 100.0)
  end

  def self.group_cost(num_books, discount_multiplier)
    num_books * UNDISCOUNTED_BOOK_PRICE * discount_multiplier
  end

  def self.single_book_cost
    UNDISCOUNTED_BOOK_PRICE
  end

  def self.multiple_non_unique_books_cost(num_books)
    UNDISCOUNTED_BOOK_PRICE * num_books
  end

  # Open the singleton class to alias module/class methods
  class << self
    alias max_undiscounted_cost multiple_non_unique_books_cost
  end

  def self.calculate_book_bundle_price(books)
    uniq_books = books.uniq
    # We have only a single book so no discount
    return single_book_cost if books.size == 1

    # We have multiple books but they are all the same
    return multiple_non_unique_books_cost(books.size) if uniq_books.size == 1 && books.size > 1

    # all books are unique so select discount percentage based on number of books
    return group_cost(books.size, calculate_discount(books.size)) if uniq_books.size == books.size

    -1.0
  end

  def self.calculate_grouped_price(basket)
    # determine the max cost which is the total undiscounted price
    max_cost = max_undiscounted_cost(basket.size)
    # We need the tallied hash sorted by the book that has the largest count for our later algorithm
    tallied_basket = basket.tally.sort_by{ |_, v| -v }.to_h

    # Start by looking for groupings that allow 5 books maximum, then 4 books maximum, then 3, then 2
    MAX_BUNDLE_SIZE.downto(MIN_BUNDLE_SIZE).each do |bundle_size|
      basket_at_tier_cost = determine_cost_of_groupings(tallied_basket.dup, bundle_size)
      # If we find a grouping that returns more than the current lowest cost its likely that we have already found the optimum price.
      break if basket_at_tier_cost > max_cost

      max_cost = basket_at_tier_cost if basket_at_tier_cost.positive? && basket_at_tier_cost < max_cost
    end
    max_cost
  end

  # Determine the total cost for groupings, using groups no bigger than bundle_size
  def self.determine_cost_of_groupings(tallied_basket, max_bundle_size)
    # determine the bundles for this iteration with the specified max bundle size
    book_bundles = determine_bundles(max_bundle_size, tallied_basket)

    # any books that are ungrouped at this point go into a separate remnant bundle
    build_bundle_of_remaining(tallied_basket, book_bundles)

    # Now apply our costing rules to each of the bundles of books in the array and accumulate the total price
    book_bundles.reduce(0.0) { |acc, book_bundle| acc + calculate_book_bundle_price(book_bundle) }
  end

  def self.determine_bundles(max_bundle_size, tallied_basket)
    book_bundles = []
    while max_bundle_size > 1 && !tallied_basket.empty?
      bundle = remove_group_of_size(max_bundle_size, tallied_basket)
      if bundle
        book_bundles << bundle
      else
        max_bundle_size -= 1
      end
    end
    book_bundles
  end

  def self.build_bundle_of_remaining(tallied_basket, book_bundles)
    return if tallied_basket.empty?

    remnants = []
    tallied_basket.each { |book_number, book_count| book_count.times { remnants << book_number } }
    book_bundles << remnants
  end

  # Determine if we can create a grouping of the specified size based on what remains
  def self.remove_group_of_size(group_size, tallied_basket)
    return unless tallied_basket.size >= group_size

    grouping = []
    keys_to_delete = []
    # we can so lets take a book from each available - pre-ordered from most books to least books
    tallied_basket.each do |book_number, book_count|
      tallied_basket[book_number] = book_count - 1
      grouping << book_number
      # if the number of copies of a book reaches zero we need to remove this book from the tally
      keys_to_delete << book_number if tallied_basket[book_number].zero?
      # stop taking books once we have filled our group to the requested group size
      break if grouping.size == group_size
    end
    keys_to_delete.each { |book_number| tallied_basket.delete(book_number) }
    grouping
  end

end

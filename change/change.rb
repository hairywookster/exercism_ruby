module Change

  class NegativeTargetError < StandardError; end
  class ImpossibleCombinationError < StandardError; end

  # Bottom Up Dynamic programming with DP/Tabulation
  # lets say for 11,  with coins 1,5,2
  #  0   1    2    3    4    5    6    7    8    9    10   11
  # [0][inf][inf][inf][inf][inf][inf][inf][inf][inf][inf][inf]
  # [0][1]  [1]  [2]  [2]  []   []   []   []   []   []   []
  # dp[i]  = min(dp[i-coin] +1)
  # Filling in one cell at a time from left to right
  def self.generate(from_coins, change_required)
    return [] if change_required.zero?
    raise NegativeTargetError unless change_required.positive?

    return [0] if change_required < 1

    dp = Array.new(change_required + 1, change_required * 1000)
    dp[0] = 0
    parent = Array.new(change_required + 1, -1)

    (1..change_required).each do |i|
      from_coins.each do |coin|
        if (i - coin) >= 0 && (dp[i - coin] + 1) < dp[i]
          dp[i] = dp[i - coin] + 1
          parent[i] = coin
        end
      end
    end

    raise ImpossibleCombinationError if dp[change_required] == change_required * 1000

    used_coins = []
    remaining = change_required
    while remaining.positive?
      used_coins << parent[remaining]
      remaining -= parent[remaining]
    end
    used_coins
  end

  # Note - A greedy algorithm as follows does not work
  # def self.greedy_algorithm(from_coins, change_required)
  #   change = []
  #   remaining_total = change_required
  #   from_coins.reverse.each do |coin|
  #     current_coin_used = true
  #     while current_coin_used
  #       if coin <= remaining_total
  #         remaining_total -= coin
  #         change << coin
  #         current_coin_used = true
  #       else
  #         current_coin_used = false
  #       end
  #     end
  #   end
  #   change.reverse
  # end

end

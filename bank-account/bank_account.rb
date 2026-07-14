class BankAccount

  def initialize
    @balance = nil
  end

  def open
    raise(ArgumentError, "You can't open an already open account") unless @balance.nil?

    @balance = 0
  end

  def balance
    raise(ArgumentError, "You can't check the balance of a closed account") if @balance.nil?

    @balance
  end

  def deposit(amount)
    raise(ArgumentError, "You can't check the balance of a closed account") if @balance.nil?
    raise(ArgumentError, "You can't deposit a nil amount") if amount.nil?
    raise(ArgumentError, "You can't deposit a negative amount") if amount.negative?

    @balance += amount
  end

  def withdraw(amount)
    raise(ArgumentError, "You can't withdraw money into a closed account") if @balance.nil?
    raise(ArgumentError, "You can't withdraw a nil amount") if amount.nil?
    raise(ArgumentError, "You can't withdraw more than you have") if @balance < amount
    raise(ArgumentError, "You can't withdraw a negative amount") if amount.negative?

    @balance -= amount
  end

  def close
    raise(ArgumentError, "You can't close an already closed account") if @balance.nil?

    @balance = nil
  end

end

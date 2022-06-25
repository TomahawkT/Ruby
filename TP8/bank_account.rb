class BankAccount
  def initialize
    raise "Debe sobreescribir este metodo"
  end

  def create(id)
    @id = id
    @balance = 0
  end

  def deposit(amount)
    @balance += amount
  end

  def extract(amount)
    raise "No cuenta con los fondos necesarios" unless extract? amount
    @balance -= amount
  end

  def extract?(amount)
    raise "Debe sobreescribir este metodo"
  end

  def to_s
    "Cuenta #{@id} con saldo #{@balance}"
  end
  private :create, :extract?
end

class CheckingAccount < BankAccount
  def initialize(id, overdraft)
    create(id)
    @overdraft = overdraft
  end

  private def extract?(amount)
    @balance + @overdraft - amount >= 0
  end
end

class SavingsAccount < BankAccount
  def initialize(id)
    create(id)
  end

  private def extract?(amount)
    @balance - amount >= 0
  end
end

class Transaction
  attr_accessor :amount

  def initialize amount
    @amount = amount
  end
end

class MintLog

  def initialize header
    @header = header
    @transactions = []
  end

  def <<(array)
    @transactions << build_trans(array)

  end

  def first
    @transactions[0]
  end

  def [](i)
    @transactions[i]
  end


  private

  def amount_idx
    @header.index 'Amount'
  end

  def trans_type_idx
    @header.index 'Transaction type'
  end

  def pos_neg array
    if array[trans_type_idx] == 'debit'
      -1.0
    else
      1.0
    end
  end

  def build_trans array
    amount = array[amount_idx].to_f * pos_neg(array)
    Transaction.new amount
  end

end

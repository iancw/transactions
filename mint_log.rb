def sanitize method_name
  method_name.downcase.gsub(/\s+/, '_')
end

class Transaction

  def initialize header, data
    header.each_with_index do |key, idx|
      define_singleton_method sanitize(key) do
        if key.eql? 'Amount'
          data[idx].to_f * pos_neg
        else
          data[idx]
        end
      end
    end
  end

  def pos_neg
    if transaction_type.eql? 'debit'
      -1.0
    else
      1.0
    end
  end
end

class MintLog

  def initialize header
    @header = header
    @transactions = []
  end

  def <<(array)
    @transactions << Transaction.new(@header, array)

  end

  def first
    @transactions[0]
  end

  def [](i)
    @transactions[i]
  end
end

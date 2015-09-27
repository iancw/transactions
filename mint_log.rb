def sanitize method_name
  method_name.downcase.gsub(/\s+/, '_')
end

class Transaction

  def initialize header, data
    @header = header
    @data = data
    define_methods
  end

  def as_csv
    as_array(@header).join ','
  end

  def add_field name, value
    if !@header.include? name
      @header << name
    end
    @data << value
    define_method name, value
  end

  private

  def define_method unsanitized_name, value
      define_singleton_method sanitize(unsanitized_name) do
        filter_value unsanitized_name, value
      end
  end

  def filter_value key, value
    if key.eql? 'Amount'
      value.to_f * pos_neg
    else
      value
    end

  end

  def define_methods
    @header.each_with_index do |key, idx|
      define_method key, @data[idx]
    end
  end


  def as_array headers
    headers.map do |header|
      self.send sanitize(header)
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

  def prev_total
    if @transactions.empty?
      0.0
    else
      @transactions.last.cumulative_amount
    end
  end

  def <<(array)
    t = Transaction.new(@header, array)
    t.add_field('Cumulative amount', prev_total + t.amount)
    @transactions << t
  end

  def first
    @transactions[0]
  end

  def [](i)
    @transactions[i]
  end

  def as_csv
    exp = @header.join ','
    exp << "\n"
    exp << @transactions.map { |trans| trans.as_csv }.join("\n")
    exp << "\n"
    exp
  end
end

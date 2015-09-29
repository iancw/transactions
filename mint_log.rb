require 'date'

def sanitize method_name
  method_name.downcase.gsub(/\s+/, '_')
end

class Transaction

  def initialize header, data
    @header = header
    @data = data
    define_methods
  end

  def as_array
    @header.map do |col|
      self.send sanitize(col)
    end
  end

  def add_field name, value
    if !@header.include? name
      @header << name
    end
    @data << value
    define_method name, value
  end

  def datetime
    DateTime.strptime(date, '%m/%d/%Y')
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

  def pos_neg
    if transaction_type.eql? 'debit'
      -1.0
    else
      1.0
    end
  end

end

class LogBuilder
  def initialize header
    @header = header
    @transactions = []
  end

  def <<(array)
    @transactions << Transaction.new(@header, array)
  end

  def add_cumulative_totals!
    prev_total = 0.0
    @transactions.each do |t|
      cur_total = prev_total + t.amount
      t.add_field('Cumulative amount', cur_total.round(2))
      prev_total = cur_total
    end
  end

  def sort!
    @transactions.sort! { |a, b| a.datetime <=> b.datetime}
  end

  def build
    sort!
    add_cumulative_totals!
    MintLog.new @header, @transactions
  end
end

class MintLog

  def initialize header, transactions
    @header = header
    @transactions = transactions
  end


  def first
    @transactions[0]
  end

  def [](i)
    @transactions[i]
  end

  def as_array
    arr = []
    arr << @header
    @transactions.each do |trans|
      arr << trans.as_array
    end
    arr
  end
end

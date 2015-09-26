require './mint_log'

describe MintLog do

  before do
    @log = MintLog.new ['Amount', 'Transaction type']
    @log << ["1.0", "debit"]
    @log << ["1.0", "credit"]
  end

  it "Should first transaction negative" do
    expect(@log.first.amount).to be < 0
  end

  it "Should have second transaction positive" do
    expect(@log[1].amount).to be > 0
  end

end

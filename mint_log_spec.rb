require './mint_log'

describe MintLog do

  before do
    @builder = LogBuilder.new ['Date', 'Amount', 'Transaction type', 'Desc']
    @builder << ['9/26/2015', '1.0', 'credit', 'Second transaction']
    @builder << ['9/25/2015', '1.0', 'debit', 'First transaction']
    @log = @builder.build
  end

  it 'Should first transaction negative' do
    expect(@log.first.amount).to be < 0
  end

  it 'Should have second transaction positive' do
    expect(@log[1].amount).to be > 0
  end

  it 'Should have first transaction with date 9/25' do
    expect(@log.first.date).to eq '9/25/2015'
  end

  it 'Should have second transaction with date 9/26' do
    expect(@log[1].date).to eq '9/26/2015'
  end

  it 'Should have first transaction with description "First transaction"' do
    expect(@log.first.desc).to eq 'First transaction'
  end

  it 'Should have second transaction with description "Second transaction"' do
    expect(@log[1].desc).to eq 'Second transaction'
  end

  it 'Should have cumulative amount' do
    expect(@log[1].cumulative_amount).to eq 0.0
  end

  it 'Should export data to CSV' do
    expect(@log.as_array).to eq [
      ["Date",'Amount','Transaction type','Desc','Cumulative amount'],
      ['9/25/2015',-1.0,'debit','First transaction',-1.0],
      ['9/26/2015',1.0,'credit','Second transaction',0.0]]
  end
end

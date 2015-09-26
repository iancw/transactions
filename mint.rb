require 'csv'
require 'net/http'
require 'uri'


class Mint

  def format_date date
    '06/01/2014'
  end

  def mint_uri date_range
    'https://wwws.mint.com/transactionDownload.event?startDate=' <<
    "#{format_date(date_range.start)}" <<
    "&endDate=#{format_date(date_range.end)}"
  end

  def fetch date_range
    uri = URI.parse mint_uri(date_range)
    response = Net::HTTP.get_response uri
    p response.body
  end

end

def old_stuff

  ARGV.each do |csv_file|
    csv = CSV.open(csv_file)
    header = csv.first
    amount_col = header.index "Amount"
    type_col = header.index "Transaction Type"
  end
end

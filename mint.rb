require 'csv'
require 'net/http'
require 'uri'


class Mint

  def format_date date
    date.strftime('%m/%d/%Y')
  end

  def mint_uri start_date, end_date
    'https://wwws.mint.com/transactionDownload.event?startDate=' <<
    "#{format_date(start_date)}" <<
    "&endDate=#{format_date(end_date)}"
  end

  def fetch start_date, end_date
    puts "Fetching from #{uri}"
    `open #{mint_uri(start_date, end_date)}`
  end
end


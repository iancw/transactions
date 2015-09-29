require './mint_log'
require 'csv'

if ARGV.empty?
  puts "Usage:  ruby gen.rb <csv file>"
  exit
end

in_csv = CSV.open ARGV[0]
builder = LogBuilder.new in_csv.first
in_csv.each do |row|
  builder << row
end
log = builder.build
CSV.open('processed.csv', 'wb') do |out_csv|
  log.as_array.each do |row|
    out_csv << row
  end
end

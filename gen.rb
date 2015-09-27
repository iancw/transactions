require './mint_log'
require 'csv'

if ARGV.empty?
  puts "Usage:  ruby gen.rb <csv file>"
  exit
end

csv = CSV.open ARGV[0]
log = MintLog.new csv.first
csv.each do |row|
  log << row
end
File.open('processed.csv', 'w') do |file|
  file.write log.as_csv
end

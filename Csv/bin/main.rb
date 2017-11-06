require_relative '../lib/csv_reader'
require_relative '../lib/exception'

puts "Enter file path name:"
file_path = gets.chomp

reader = CsvReader.new(file_path)
begin
  reader.read_in_csv_data
  p reader.items
rescue InvalidExtensionError => e
  puts e.message.to_s
rescue ClassAlreadyExistsError => e
  puts e.message.to_s
rescue SpaceInsideFileNameError => e
  puts e.message.to_s
rescue InvalidHeaderError => e
  puts e.message.to_s
end




# /home/jayanti/AdvancedRuby/csv_file.csv

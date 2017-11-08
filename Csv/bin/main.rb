require_relative '../lib/csv_reader'
require_relative '../lib/exception'

puts "Enter file path name:"
file_path = gets.chomp

reader = CsvReader.new(file_path)
begin
  reader.process
  p reader.items
rescue InvalidExtensionError => e
  puts e.message
rescue ClassAlreadyExistsError => e
  puts e.message
rescue SpaceInsideFileNameError => e
  puts e.message
rescue InvalidHeaderError => e
  puts e.message
end

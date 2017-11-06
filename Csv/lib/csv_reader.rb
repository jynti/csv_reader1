require 'csv'

class CsvReader
  attr_reader :items
  def initialize(csv_file_path)
    @items = []
    @csv_file_path = csv_file_path
  end

  def create_file_name
    @csv_file_name = File.basename(@csv_file_path, ".*")
  end

  def invalid_file_name?
    raise InvalidExtensionError, "Only csv files valid" unless File.extname(@csv_file_path).eql?(".csv")
    raise SpaceInsideFileNameError, "There is a whitespace in your file name" if @csv_file_name.match(/\s/)
    raise ClassAlreadyExistsError, "#{@csv_file_name.capitalize} class already exists" if Object.const_defined? @csv_file_name.capitalize
  end

  def create_class
    create_file_name
    unless invalid_file_name?
      @csv_class = Object.const_set(@csv_file_name.match(/[a-zA-Z]+/)[0].capitalize, Class.new)
    end
  end

  def invalid_headers?
    @headers.each do |header|
      invalid_header = %w{__FILE__ __LINE__ alias and begin BEGIN break case class def defined? do else elsif end END ensure false for if in module next nil not or redo rescue retry return self super then true undef unless until when while yield}.include? header.downcase
      raise InvalidHeaderError, "'#{header}' is invalid as a header name" if invalid_header
    end
    false
  end

  def create_methods_for_class
    @headers = CSV.read(@csv_file_path, headers: true).headers
    unless invalid_headers?
      @headers.each do |method_name|
        @csv_class.class_eval do
          instance_variable_name = "@#{method_name}"
          define_method("#{method_name}=") do |value|
            instance_variable_set(instance_variable_name, value)
          end
          define_method(method_name) do
            instance_variable_get(instance_variable_name)
          end
        end
      end
    end
  end

  def read_in_csv_data
    create_class
    create_methods_for_class
    CSV.foreach(@csv_file_path, headers: true) do |row|
      csv_object = @csv_class.new
      @headers.each do |header|
        csv_object.send("#{header}=", row[header])
      end
      items << csv_object
    end
  end
end



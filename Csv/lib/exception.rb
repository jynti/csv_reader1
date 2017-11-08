class InvalidExtensionError < StandardError
  def initialize
    super("Only csv files valid")
  end
end

class ClassAlreadyExistsError < StandardError

end

class SpaceInsideFileNameError < StandardError
  def initialize
    super("There is a whitespace in your file name")
  end
end

class InvalidHeaderError < StandardError

end



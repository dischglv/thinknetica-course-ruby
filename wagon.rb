class Wagon
  include Manufactured
  include Validation

  attr_reader :number

  def initialize(number)
    @number = number
    validate!
  end

  protected
  attr_writer :number

  def validate!
    raise "Номер поезда не может быть nil" if self.number.nil?
  end
end
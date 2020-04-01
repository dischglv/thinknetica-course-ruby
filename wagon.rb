class Wagon
  include Manufactured
  include Validation

  attr_reader :number, :capacity, :free_space

  def initialize(number, capacity)
    @number = number
    @capacity = capacity.to_i
    @free_space = @capacity
    validate!
  end

  def take_up_space(amount)
    free_space > amount ? self.free_space -= amount : self.free_space = 0
  end

  def occupied_space
    capacity - free_space
  end

  protected
  attr_writer :number, :capacity, :free_space

  def validate!
    raise "Номер поезда не может быть nil" if number.nil?
    raise "Вместимость не может быть nil" if capacity.nil?
    raise "Вместимость быть положительным числом" unless capacity > 0
  end
end
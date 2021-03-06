class Station
  include InstanceCounter
  include Validation

  attr_reader :name, :trains
  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name.to_s
    @trains = []
    validate!
    @@stations << self
    register_instance
  end

  def accept_train(train)
    self.trains << train
  end

  def send_train(train)
    self.trains.delete(train)
  end

  def trains_by_type(type)
    self.trains.select { |train| train.class == type }
  end

  def trains_number_by_type(type)
    self.trains.count { |train| train.class == type }
  end

  def each_train(&block)
    if block_given?
      self.trains.each { |train| yield(train) }
    end
  end

  protected
  # извне можем только получать массив поездов, находящихся на станции, записываем в массив явно только внутри класса
  # для добавления/удаления поездов на станцию существуют отдельные методы 
  attr_writer :trains

  def validate!
    raise "Имя не может быть пустым" if self.name == ""
  end
end
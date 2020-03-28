class Station
  include InstanceCounter

  attr_reader :name, :trains
  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name.to_s
    @trains = []
    @@stations << self
    register_instance
    raise "Объект невалидный" if !valid?
  end

  def valid?
    return false if name == ""
    true
  end

  def accept_train(train)
    raise "Аргумент должен быть принадлежать классу Train или одному из его подклассов" if !(train.is_a? Train)
    self.trains << train
  end

  def send_train(train)
    raise "Аргумент должен быть принадлежать классу Train или одному из его подклассов" if !(train.is_a? Train)
    self.trains.delete(train)
  end

  def trains_by_type(type)
    raise "Типом может быть 'PassengerTrain' или 'CargoTrain'" if type != PassengerTrain or type != CargoTrain
    self.trains.select { |train| train.class == type }
  end

  def trains_number_by_type(type)
    raise "Типом может быть 'PassengerTrain' или 'CargoTrain'" if type != PassengerTrain or type != CargoTrain
    self.trains.count { |train| train.class == type }
  end

  protected
  # извне можем только получать массив поездов, находящихся на станции, записываем в массив явно только внутри класса
  # для добавления/удаления поездов на станцию существуют отдельные методы 
  attr_writer :trains

end
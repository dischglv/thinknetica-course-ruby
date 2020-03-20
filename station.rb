class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def accept_train(train)
    self.trains << train
  end

  def send_train(train)
    self.trains.delete(train)
  end

  def trains_by_type(type)
    self.trains.select { |train| train.type == type }
  end

  def trains_number_by_type(type)
    self.trains.count { |train| train.type == type }
  end

  private
  # добавлен внутренний сеттер для массива поездов
  # массив доступен для изменения только внутри класса, изменять извне его можно только с помощью интерфейса класса
  # private - т.к. на данном этапе у класса Train нет подклассов
  attr_writer :trains

end
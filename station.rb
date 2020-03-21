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
    self.trains.select { |train| train.class == type }
  end

  def trains_number_by_type(type)
    self.trains.count { |train| train.class == type }
  end

  protected
  attr_writer :trains

end
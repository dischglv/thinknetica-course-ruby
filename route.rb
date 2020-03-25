class Route
  include InstanceCounter

  attr_reader :stations

  def initialize(start_station, end_station)
    @stations = [start_station, end_station]
    register_instance
  end

  def add_station(station)
    self.stations.insert(-2, station)
  end

  def delete_station(station)
    first = first_station
    last = last_station
    self.stations.delete(station)
    self.stations[0] = first
    self.stations[-1] = last
  end

  def show_stations
    self.stations.each { |station| puts station.name }
  end

  def at(number)
    self.stations[number]
  end

  def length
    self.stations.length
  end

  def first_station
    self.stations[0]
  end

  def last_station
    self.stations[-1]
  end

  protected
  # изменение массива станций должно быть доступно только изнутри класса
  # для изменения массива станций извне существуют отдельные методы из интерфейса класса
  attr_writer :stations
end
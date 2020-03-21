class Route
  attr_reader :stations

  def initialize(start_station, end_station)
    @stations = [start_station, end_station]
  end

  def add_station(station)
    self.stations.insert(-2, station)
  end

  def delete_station(station)
    self.stations.delete(station)
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
  # изменение станций должно быть доступно только изнутри массива
  attr_writer :stations
end
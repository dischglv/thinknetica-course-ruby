class Route
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

  private
  # геттер и сеттер для массива станций, доступ к массиву возможен только из методов класса
  # private - т.к. у класса нет подклассов
  attr_accessor :stations
end
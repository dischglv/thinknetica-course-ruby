class Route
  def initialize(start_station, end_station)
    @stations = [start_station, end_station]
  end

  def add_station(station)
    @stations.insert(-2, station)
  end

  def delete_station(station)
    @stations.delete(station)
  end

  def show_stations
    @stations.each { |station| puts station.name }
  end

  def at(number)
    @stations[number]
  end

  def length
    @stations.length
  end

  def first_station
    @stations[0]
  end

  def last_station
    @stations[-1]
  end
end
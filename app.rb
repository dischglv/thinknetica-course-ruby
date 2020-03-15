class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def accept_train(train)
    @trains << train
  end

  def trains_by_type(type)
    @trains.select { |train| train.type == type }
  end

  def trains_number_by_type(type)
    @trains.count { |train| train.type == type }
  end

  def send_train(train)
    @trains.delete(train)
  end
end

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

class Train
  attr_reader :length, :number, :type

  # possible types - 'passenger', 'cargo'
  def initialize(number, type, length)
    @number = number
    @type = type
    @length = length > 0 ? length : 0
    @speed = 0
  end

  def increase_speed(value)
    @speed += value
  end

  def decrease_speed(value)
    (@speed - value) > 0 ? @speed -= value : @speed = 0
  end

  def hitch_wagon
    @length += 1 if @speed == 0
  end

  def uncouple_wagon
    @length -= 1 if @speed == 0 && @length > 0
  end

  def take_route(route)
    current_station.send_train(self) if !(@route.nil?)
    @route = route
    @current_station_number = 0
    current_station.accept_train(self)
  end

  def move_on
    if next_station
      current_station.send_train(self)
      next_station.accept_train(self)
      @current_station_number += 1
    end
  end

  def move_back
    if previous_station
      current_station.send_train(self)
      previous_station.accept_train(self)
      @current_station_number -= 1
    end
  end

  def current_station
    @route.at(@current_station_number)
  end

  def previous_station
    @route.at(@current_station_number - 1) if current_station != @route.first_station
  end

  def next_station
    @route.at(@current_station_number + 1) if current_station != @route.last_station
  end
end
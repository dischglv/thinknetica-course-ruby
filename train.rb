class Train
  attr_reader :length, :number, :type

  # possible types - 'passenger', 'cargo'
  def initialize(number, type)
    @number = number
    @type = type
    @speed = 0
    @wagons = []
  end

  def increase_speed(value)
    self.speed += value
  end

  def decrease_speed(value)
    self.speed > value ? self.speed -= value : stop
  end

  def hitch_wagon(wagon)
    self.wagons.push(wagon) if train_stopped? && !self.wagons.include?(wagon)
  end

  def uncouple_wagon(wagon)
    self.wagons.delete(wagon) if train_stopped? && self.wagons.include?(wagon)
  end

  def take_route(route)
    current_station.send_train(self) if !(self.route.nil?)
    self.route = route
    self.current_station_number = 0
    current_station.accept_train(self)
  end

  def move_on
    if next_station
      current_station.send_train(self)
      next_station.accept_train(self)
      self.current_station_number += 1
    end
  end

  def move_back
    if previous_station
      current_station.send_train(self)
      previous_station.accept_train(self)
      self.current_station_number -= 1
    end
  end

  def current_station
    self.route.at(self.current_station_number)
  end

  def previous_station
    self.route.at(self.current_station_number - 1) if current_station != self.route.first_station
  end

  def next_station
    self.route.at(self.current_station_number + 1) if current_station != self.route.last_station
  end

  protected
  attr_accessor :speed, :route, :wagons, :current_station_number

  def train_stopped?
    self.speed.zero?
  end

  def stop
    self.speed = 0
  end
end
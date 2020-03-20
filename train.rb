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
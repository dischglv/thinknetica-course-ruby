class Train
  include Manufactured
  include InstanceCounter
  INITIAL_SPEED = 0

  @@trains = {}

  attr_reader :length, :number, :type, :wagons

  def self.find(number)
    @@trains[number]
  end

  def initialize(number)
    @number = number.to_s
    @speed = INITIAL_SPEED
    @wagons = []
    @@trains[number] = self
    register_instance
    raise "Объект невалидный" unless valid?
  end

  def valid_number?
    return true if (self.number =~ /^([a-zа-я]|\d){3}-?([a-zа-я]|\d){2}$/i) == 0
    false
  end

  def valid?
    return valid_number?
  end

  def increase_speed(value)
    self.speed += value
  end

  def decrease_speed(value)
    self.speed > value ? self.speed -= value : stop
  end

  def hitch_wagon(wagon)
    raise "Аргумент должен принадлежать классу Wagon или одному из его подклассов" unless wagon.is_a? Wagon
    self.wagons.push(wagon) if train_stopped? && !self.wagons.include?(wagon)
  end

  def uncouple_wagon(wagon)
    raise "Аргумент должен принадлежать классу Wagon или одному из его подклассов" unless wagon.is_a? Wagon
    self.wagons.delete(wagon) if train_stopped? && self.wagons.include?(wagon)
  end

  def take_route(route)
    raise "Аргумент должен принадлежать классу Route" unless route.is_a? Route
    current_station.send_train(self) unless self.route.nil?
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

  protected
  # вынесли в protected (так как есть подклассы) все, что не входит в интерфейс класса
  # скорость, маршрут, текущий номер станции - внутренние переменные
  # вагоны доступны снаружи на чтение (используется в menu)
  attr_accessor :speed, :route, :current_station_number
  attr_writer :wagons

  # следующие методы используются только внутри класса
  def current_station
    self.route.at(self.current_station_number)
  end

  def previous_station
    self.route.at(self.current_station_number - 1) unless current_station == self.route.first_station
  end

  def next_station
    self.route.at(self.current_station_number + 1) unless current_station == self.route.last_station
  end

  def train_stopped?
    self.speed.zero?
  end

  # снаружи доступно только увеличение/уменьшение скорости, внутренний метод
  def stop
    self.speed = 0
  end
end
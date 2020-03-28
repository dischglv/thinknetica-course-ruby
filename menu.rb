class Menu

  def initialize
    @wagons = []
    @trains = []
    @stations = []
    @routes = []
  end

  def show_options
    loop do
      puts ''
      puts 'Введите 1 чтобы создать объект (станцию, поезд или маршрут)'
      puts 'Введите 2 чтобы изменить объект'
      puts 'Введите 3 чтобы посмотреть все все станции или все поезда на станции'
      puts 'Введите 4 чтобы запустить seed метод'
      puts 'Введите 0 чтобы выйти'
      answer = gets.chomp
      case answer
      when '1'
        show_create_options
      when '2'
        show_manage_options
      when '3'
        show_listing_options
      when '4'
        seed
      when '0'
        break
      end
    end
  end

  def seed
    self.stations << Station.new('Москва Октябрьская')
    self.stations << Station.new('Тверь')
    self.stations << Station.new('Бологое - Московское')
    self.stations << Station.new('Санкт-Петербург - Главн.')
    self.routes << Route.new(stations[0], stations[-1])

    train1 = PassengerTrain.new('754-3А')
    train1.take_route(routes[0])
    self.trains << train1

    train2 = CargoTrain.new('755РА')
    train2.take_route(routes[0])
    self.trains << train2
  end

  protected
  attr_accessor :stations, :routes, :trains

  private
  def show_create_options
    puts ''
    puts 'Введите 1 чтобы создать станцию'
    puts 'Введите 2 чтобы создать поезд'
    puts 'Введите 3 чтобы создать маршрут'
    case gets.chomp
    when '1'
      create_station
    when '2'
      create_train
    when '3'
      create_route
    else
      return
    end
  end

  def show_manage_options
    puts ''
    puts 'Введите 1 чтобы добавить станцию к маршруту'
    puts 'Введите 2 чтобы удалить станцию из маршрута'
    puts 'Введите 3 чтобы назначить маршрут поезду'
    puts 'Введите 4 чтобы прицепить вагон к поезду'
    puts 'Введите 5 чтобы отцепить вагон от поезда'
    puts 'Введите 6 чтобы переместить поезд'
    case gets.chomp
    when '1'
      add_station_to_route
    when '2'
      delete_station_from_route
    when '3'
      assign_route_to_train
    when '4'
      hitch_wagon_to_train
    when '5'
      uncouple_wagon_from_train
    when '6'
      move_train
    else
      return
    end
  end

  def show_listing_options
    puts ''
    puts 'Введите 1 чтобы вывести список всех станций'
    puts 'Введите 2 чтобы вывести список всех поездов на станции'
    case gets.chomp
    when '1'
      show_stations
    when '2'
      show_trains_at_station
    else 
      return
    end
  end

  def create_station
    puts ''
    puts 'Введите название станции'
    name = gets.chomp
    self.stations.push(Station.new(name))
  end

  def create_train
    puts ''
    puts 'Введите номер поезда'
    number = gets.chomp
    puts 'Введите 1 чтобы создать пассажирский поезд'
    puts 'Введите 2 чтобы создать грузовой поезд'
    case gets.chomp
    when '1'
      train = PassengerTrain.new(number)
      puts "Создан пассажирский поезд номер #{number}"
    when '2'
      train = CargoTrain.new(number)
      puts "Создан грузовой поезд номер #{number}"
    else
      return
    end
    self.trains.push(train)
    rescue RuntimeError => e
      raise unless e.message == "Объект невалидный"
      print "Номер введен в неправильном формате. Попробовать еще раз? (да/нет) "
      retry if gets.chomp == "да"
  end

  def create_route
    puts ''
    if self.stations.empty?
      puts 'Добавьте хотя бы одну станцию для создания маршрута'
      return
    end
    puts 'Выберите начальную станцию маршрута'
    first_station = choose_station
    puts 'Выберите конечную станцию маршрута'
    last_station = choose_station
    route = Route.new(first_station, last_station)
    self.routes.push(route)
  end

  def add_station_to_route
    puts ''
    if self.routes.empty?
      puts 'Нет маршрута для изменения'
      return
    end
    puts 'Выберите маршрут, к которому хотите добавить станцию'
    route = choose_route
    puts 'Выберите станцию, которую хотите добавить к маршруту'
    station = choose_station
    route.add_station(station)
  end

  def delete_station_from_route
    puts ''
    if self.routes.empty?
      puts 'Нет маршрута для изменения'
      return
    end
    puts 'Выберите маршрут, который хотите изменить'
    route = choose_route
    puts 'Выберите станцию, которую хотите удалить'
    station = choose_from_array(route.stations, 'Станция')
    route.delete_station(station)
  end

  def assign_route_to_train
    puts ''
    if self.trains.empty? || self.routes.empty?
      puts 'Создайте поезд и маршрут'
      return
    end
    puts 'Выберите поезд'
    train = choose_train
    puts 'Выберите маршрут, который хотите назначить поезду'
    route = choose_route
    train.take_route(route)
  end

  def hitch_wagon_to_train
    puts ''
    if self.trains.empty?
      puts 'Создайте поезд для изменения'
      return
    end
    puts 'Выберите поезд'
    train = choose_train
    wagon = train.class == 'PassengerTrain' ? PassengerWagon.new : CargoWagon.new
    train.hitch_wagon(wagon)
  end

  def uncouple_wagon_from_train
    puts ''
    if self.trains.empty?
      puts 'Создайте поезд для изменения'
      return
    end
    puts 'Выберите поезд'
    train = choose_train
    puts 'Выберите вагон, который хотите отцепить'
    wagon = choose_from_array(train.wagons, 'Вагон')
    train.uncouple_wagon(wagon)
  end

  def move_train
    puts ''
    if self.trains.empty?
      puts 'Создайте поезд для изменения'
      return
    end
    puts 'Выберите поезд'
    train = choose_train
    puts 'Введите 1 чтобы переместить поезд на станцию вперед'
    puts 'Введите 2 чтобы переместить поезд на станцию назад'
    case gets.chomp
    when '1'
      train.move_on
    when '2'
      train.move_back
    end
  end

  def show_stations
    puts ''
    puts 'Не создано ни одной станции' if self.stations.empty?
    self.stations.each { |station| puts station.name }
  end

  def show_trains_at_station
    puts ''
    if self.stations.empty?
      puts 'Не создано ни одной станции'
      return
    end
    puts 'Выберите станцию'
    station = choose_station
    if station.trains.empty?
      puts 'На станции нет поездов'
      return
    end
    station.trains_by_type(PassengerTrain).each do |train|
      puts "Пассажирский поезд номер #{train.number}"
    end
    station.trains_by_type(CargoTrain).each do |train|
      puts "Грузовой поезд номер #{train.number}"
    end
  end

  def choose_station
    choose_from_array(self.stations, 'Станция')
  end

  def choose_route
    choose_from_array(self.routes, 'Маршрут')
  end

  def choose_train
    choose_from_array(self.trains, 'Поезд')
  end

  def choose_from_array(array, item_name)
    index = 0
    array.each do |item|
      puts "#{item_name} #{index + 1}: #{array[index].inspect}"
      index += 1
    end
    array[gets.chomp.to_i - 1]
  end
end
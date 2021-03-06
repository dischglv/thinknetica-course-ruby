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
      puts 'Введите 3 чтобы посмотреть все станции или все поезда на станции'
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

    10.times do
      number = rand(100)
      seats = rand(120)
      wagon = PassengerWagon.new(number, seats)
      train1.hitch_wagon(wagon)

      number = rand(100)
      volume = rand(1200)
      wagon = CargoWagon.new(number, volume)
      train2.hitch_wagon(wagon)
    end
  end

  protected
  attr_accessor :stations, :routes, :trains

  def passenger_trains
    self.trains.select { |train| train.class == PassengerTrain }
  end

  def cargo_trains
    self.trains.select { |train| train.class == CargoTrain }
  end

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
    puts 'Введите 7 чтобы занять место в пассажирском вагоне'
    puts 'Введите 8 чтобы занять объем в грузовом вагоне'
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
    when '7'
      take_seat
    when '8'
      take_space
    else
      return
    end
  end

  def show_listing_options
    puts ''
    puts 'Введите 1 чтобы вывести список всех станций'
    puts 'Введите 2 чтобы вывести список всех поездов на станции'
    puts 'Введите 3 чтобы вывести список всех вагонов поезда'
    case gets.chomp
    when '1'
      show_stations
    when '2'
      show_trains_at_station
    when '3'
      show_wagons
    else 
      return
    end
  end

  def create_station
    puts ''
    puts 'Введите название станции'
    name = gets.chomp
    station = Station.new(name)
    self.stations.push(station)
    station
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
    train
  rescue RuntimeError => e
    raise unless e.message == 'Невалидный формат номера'
    print 'Номер введен в неправильном формате. Попробовать еще раз? (да/нет) '
    retry if gets.chomp == 'да'
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
    route
  end

  def create_passenger_wagon
    puts ''
    print 'Задайте количество мест в вагоне: '
    seats = gets.chomp
    number = rand(100)
    wagon = PassengerWagon.new(number, seats)
    wagon
  rescue RuntimeError => e
    puts 'Данные заданы в неверном формате:'
    puts e.message
    print 'Хотите попробовать еще раз? (да/нет) '
    retry if gets.chomp == 'да'
  end

  def create_cargo_wagon
    puts ''
    print 'Задайте объем вагона: '
    volume = gets.chomp
    number = rand(100)
    wagon = CargoWagon.new(number, volume)
    wagon
  rescue RuntimeError => e
    puts 'Данные заданы в неверном формате:'
    puts e.message
    print 'Хотите попробовать еще раз? (да/нет) '
    retry if gets.chomp == 'да'
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
    wagon = train.class == 'PassengerTrain' ? create_passenger_wagon : create_cargo_wagon
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

  def take_seat
    puts ''
    if passenger_trains.empty?
      puts 'Пассажирских поездов не создано'
      return
    end
    puts 'Выберите поезд'
    train = choose_from_array(passenger_trains)
    if train.wagons.empty?
      puts 'У поезда нет вагонов'
      return
    end
    puts 'Выберите вагон'
    wagon = choose_from_array(train.wagons)
    if wagon.free_space > 0
      wagon.take_up_space
      puts 'Место успешно занято'
    else
      puts 'Свободных мест нет'
    end
  end

  def take_space
    puts ''
    if cargo_trains.empty?
      puts 'Грузовых вагонов не создано'
      return
    end
    puts 'Выберите поезд'
    train = choose_from_array(cargo_trains)
    if train.wagons.empty?
      puts 'У поезда нет вагонов'
      return
    end
    puts 'Выберите вагон'
    wagon = choose_from_array(train.wagons)
    if wagon.free_space > 0
      puts "В вагоне осталось свободного места: #{wagon.free_space}"
      print 'Введите объем, который хотите занять: '
      volume = gets.chomp.to_i
      wagon.take_up_space(volume)
    else
      puts 'В вагоне не осталось свободного места'
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
    station.each_train do |train|
      type = train.class == PassengerTrain ? 'пассажирский' : 'грузовой'
      puts ''
      puts "Номер: #{train.number}, тип: #{type}, количество вагонов: #{train.wagons.length}"
      show_train_wagons(train)
    end
  end

  def show_wagons
    puts ''
    if self.trains.empty?
      puts 'Поездов нет'
      return
    end
    train = choose_train
    show_train_wagons(train)
  end

  def show_train_wagons(train)
    if train.wagons.empty?
      puts 'Поезд без вагонов'
      return
    end
    type = train.class == PassengerTrain ? 'пассажирский' : 'грузовой'
    train.each_wagon do |wagon|
      puts "Номер вагона: #{wagon.number}, тип: #{type}"
      if type == 'пассажирский'
        puts "Количество свободных мест: #{wagon.free_space}"
        puts "Количество занятых мест: #{wagon.occupied_space}"
      else
        puts "Количество свободного объема: #{wagon.free_space}"
        puts "Количество занятого объема: #{wagon.occupied_space}"
      end
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
      puts "#{item_name} #{index + 1}: #{array[index].to_s}"
      index += 1
    end
    array[gets.chomp.to_i - 1]
  end
end
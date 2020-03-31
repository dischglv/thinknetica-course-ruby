require_relative 'wagon.rb'

class PassengerWagon < Wagon
    attr_reader :seats, :empty_seats

    def initialize(number, seats)
        @seats = seats
        super(number)
        @empty_seats = seats
    end

    def take_seat
        self.empty_seats -= 1 unless self.empty_seats == 0
    end

    def occupied_seats
        self.seats - self.empty_seats
    end

    protected
    attr_writer :seats, :empty_seats

    def validate!
        super
        raise "Количество мест должно быть не nil" if self.seats.nil?
        raise "Количество мест должно быть неотрицательным числом" if self.seats < 0
    end
end
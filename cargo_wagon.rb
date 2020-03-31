require_relative 'wagon.rb'

class CargoWagon < Wagon
    attr_reader :volume, :free_space

    def initialize(number, volume)
        @volume = volume.to_f
        super(number)
        @free_space = volume
    end

    def take_up_space(volume)
        self.free_space > volume ? self.free_space - volume : self.free_space = 0
    end

    def occupied_space
        self.volume - self.free_space
    end

    protected
    attr_writer :volume, :free_space

    def validate!
        super
        raise "Объем вагона не может быть nil" if self.volume.nil?
        raise "Объем вагона должен быть положительным числом" unless self.volume > 0
    end
end
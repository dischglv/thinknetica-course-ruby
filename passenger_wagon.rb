require_relative 'wagon.rb'

class PassengerWagon < Wagon
    def take_up_space
        super(1)
    end
end
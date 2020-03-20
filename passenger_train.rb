require_relative 'train.rb'

class PassengerTrain < Train
  def hitch_wagon(wagon)
    super(wagon) if wagon.class == 'PassengerWagon'
  end
end
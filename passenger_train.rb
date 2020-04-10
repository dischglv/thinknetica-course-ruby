require_relative 'train.rb'

class PassengerTrain < Train
  validate :number, NUMBER_FORMAT

  def hitch_wagon(wagon)
    super(wagon) if wagon.class == 'PassengerWagon'
  end
end
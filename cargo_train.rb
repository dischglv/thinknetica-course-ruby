require_relative 'train.rb'

class CargoTrain < Train
  validate :number, NUMBER_FORMAT

  def hitch_wagon(wagon)
    super(wagon) if wagon.class == 'CargoWagon'
  end
end
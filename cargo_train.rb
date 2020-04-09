require_relative 'train.rb'

class CargoTrain < Train
  def hitch_wagon(wagon)
    super(wagon) if wagon.class == CargoWagon
  end
end
class PassengerTrain < Train
  def hitch_wagon(wagon)
    super(wagon) if wagon.class == 'PassengerWagon'
  end
end
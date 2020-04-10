class Wagon
  include Manufactured
  extend Accessor

  attr_accessor_with_history :color
end
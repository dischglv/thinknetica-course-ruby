module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def validate(name, type, arg)
      validations = class_variable_get(:@@validations)
      validations ||= Hash.new
      validations[name] ||= Hash.new
      validations[name][type] = arg
      class_variable_set(:@@validations)
    end
  end

  module InstanceMethods
    def validate!
      validations = class_variable_get(:@@validations)
    end

    def valid?
      validate!
      true
    rescue
      false
    end
  end
end
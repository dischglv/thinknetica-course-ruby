module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def validate(name, type, arg = nil)
      if class_variable_defined? :@@validations
        validations = class_variable_get(:@@validations) 
      end
      validations ||= Hash.new
      validations[name] ||= Hash.new
      validations[name][type] = arg
      class_variable_set(:@@validations, validations)
    end
  end

  module InstanceMethods
    def validate!
      validations = self.class.class_variable_get(:@@validations)
      validations.each_key do |name|
        var_name = "@#{name}".to_sym
        var_value = instance_variable_get(var_name)
        validations[name].each do |type, arg|
          case type
          when :presence
            raise "Атрибут #{var_name} не может быть nil" if var_value.nil?
            raise "Атрибут #{var_name} не может быть пустой строкой" if var_value == ''
          when :format
            raise "Невалидный формат атрибута #{var_name}" if var_value !~ arg
          when :type
            if var_value.instance_of? Array
              var_value.each do |value|
                raise "Атрибут #{var_name} не соответствует заданному классу" unless value.is_a? arg
              end
            else
              raise "Атрибут #{var_name} не соответствует заданному классу" unless var_value.is_a? arg
            end
          end
        end
      end
    end

    def valid?
      validate!
      true
    rescue
      false
    end
  end
end
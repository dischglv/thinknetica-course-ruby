module Accessor
  def attr_accessor_with_history(*names)    
    names.each do |name|
      var_name = "@#{name}".to_sym
      var_values = "@#{name}_values".to_sym

      define_method(name) do
        instance_variable_get(var_name)
      end

      define_method("#{name}=".to_sym) do |value|
        values = instance_variable_get(var_values)
        if values
          values << value
          instance_variable_set(var_values, values)
        else
          instance_variable_set(var_values, [value])
        end
        instance_variable_set(var_name, value)
      end

      define_method("#{name}_history") do
        values = instance_variable_get(var_values)
        values ? values : []
      end
    end
  end

  def strong_attr_accessor(name, var_class)
    var_name = "@#{name}".to_sym
    define_method(name) do
      instance_variable_get(var_name)
    end

    define_method("#{name}=".to_sym) do |value|
      raise 'Не совпадает тип переменной' unless value.is_a? var_class
      instance_variable_set(var_name, value)
    end
  end
end
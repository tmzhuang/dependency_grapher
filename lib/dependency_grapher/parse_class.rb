module DependencyGrapher
  module ParseClass
    module_function
    def call(klass)
      anon_class_pattern?(klass.inspect) ? parse_anon_class_name(klass.inspect) : klass.inspect
    end

    private_class_method
    # #<#<Class:0x007fd550c04338>:0x007fd550c04450> matches with groups:
    # 1.#<Class:0x007fd550c04338>
    # 2.0x007fd550c04450
    def nested_anon_pattern 
      /#<(#<.*>):(.*)>/
    end

    # #<Class:0x007fd550c04338> matches with groups:
    # 1.Class
    # 2.0x007fd550c04338
    def anon_pattern 
      /#<(Class|Module):([^>]*)>/
    end

    def anon_class_pattern?(name)
      name.match(nested_anon_pattern) || name.match(anon_pattern)
    end

    # Given #<#<Class:0x007fd550c04338>:0x007fd550c04450>, returns string
    # "0x007fd550c04338::0x007fd550c04450" using a recursive function
    def parse_anon_class_name(name)
      if match = name.match(nested_anon_pattern)
        parse_anon_class_name(match[1]) + "::#{match[2]}"
      elsif match = name.match(anon_pattern)
        match[2]
      else
        raise "Unrecognized format for Class or Module: #{name}."
      end
    end
  end

end

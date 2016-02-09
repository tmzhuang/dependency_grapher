module DependencyGrapher
  class Method
    attr_reader :defined_class, :method_id

    def initialize(defined_class, method_id)
      @defined_class = defined_class
      @method_id = method_id
    end
  end
end

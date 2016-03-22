require 'yaml'

module DependencyGrapher
  class Method
    attr_reader :defined_class, :method_id

    def initialize(defined_class, method_id)
      @defined_class = defined_class.to_s
      @method_id = method_id.to_s
    end

    def nesting
      @defined_class.split("::")
    end

    def root
      nesting.first
    end

    def clef
      nesting.last
    end

    #def to_yaml
      #YAML.dump(self)
    #end

    #def self.from_yaml(string)
      #YAML.load(string)
    #end

    def serialize
      YAML.dump(self)
    end

    def self.deserialize(string)
      YAML.load(string)
    end
  end
end

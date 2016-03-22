module DependencyGrapher
  class Dependency
    attr_reader :caller, :receiver

    def initialize(caller, receiver)
      @caller = caller
      @receiver = receiver
    end

    def serialize
      YAML.dump(self)
    end

    def self.deserialize(string)
      YAML.load(string)
    end
  end
end

module DependencyGrapher
  class Dependency
    attr_reader :caller, :receiver

    def initialize(caller, receiver)
      @caller = caller
      @receiver = receiver
    end
  end
end

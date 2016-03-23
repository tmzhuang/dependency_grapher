require_relative 'serialize_helpers'

module DependencyGrapher
  class Dependency
    include DependencyGrapher::SerializeHelpers
    attr_reader :caller, :receiver

    def initialize(caller, receiver)
      @caller = caller
      @receiver = receiver
    end
  end
end

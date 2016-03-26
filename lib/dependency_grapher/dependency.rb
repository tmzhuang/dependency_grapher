require_relative 'serialize_helpers'

module DependencyGrapher
  class Dependency
    include DependencyGrapher::SerializeHelpers
    attr_reader :caller, :receiver, :flag

    def initialize(caller, receiver)
      @caller = caller
      @receiver = receiver
      @flag = :normal
    end
  end
end

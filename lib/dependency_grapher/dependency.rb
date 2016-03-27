require 'set'
require_relative 'serialize_helpers'

module DependencyGrapher
  class Dependency
    include DependencyGrapher::SerializeHelpers
    attr_reader :caller, :receiver
    attr_accessor :flags

    def initialize(caller, receiver)
      @caller = caller
      @receiver = receiver
      @flags = Set.new
    end
  end
end

require 'set'
require_relative 'serialize_helpers'

module DependencyGrapher
  class Dependency
    include DependencyGrapher::SerializeHelpers
    attr_reader :kaller, :receiver, :count
    # TODO Fix LOD violation (flag should not be directly exposed)
    attr_accessor :flags

    def initialize(kaller, receiver)
      @kaller = kaller
      @receiver = receiver
      @flags = Set.new
      @count = 1
    end

    def id
      @kaller.id + @receiver.id
    end

    def touch
      @count += 1
    end
  end
end

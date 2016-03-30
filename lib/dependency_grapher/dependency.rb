require 'set'
require_relative 'serialize_helpers'

module DependencyGrapher
  class Dependency
    include DependencyGrapher::SerializeHelpers
    attr_reader :kaller, :receiver, :count
    attr_accessor :flags

    def initialize(kaller, receiver)
      @kaller = kaller
      @receiver = receiver
      @flags = Set.new
      @count = 1
    end

    def full_id
      @kaller.full_id + @receiver.full_id
    end

    def touch
      @count += 1
    end
  end
end

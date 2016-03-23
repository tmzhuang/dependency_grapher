require 'yaml'
require_relative 'serialize_helpers'

module DependencyGrapher
  class Method
    include DependencyGrapher::SerializeHelpers
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

  end
end

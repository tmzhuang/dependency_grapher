require 'yaml'
require_relative 'serialize_helpers'

module DependencyGrapher
  class Method
    attr_reader :defined_class, :method_id
    include DependencyGrapher::SerializeHelpers
    Limit = 50

    def initialize(defined_class, method_id)
      # Truncate class name to limit characters if too lon
      defined_class = defined_class[0,Limit] + "..." if defined_class.length > Limit
      @defined_class = defined_class
      @method_id = method_id
    end

    def ancestors
      binding.pry if @defined_class.nil?
      @defined_class.split("::")
    end

    def root
      ancestors.first
    end

    def leaf
      ancestors.last
    end

  end
end

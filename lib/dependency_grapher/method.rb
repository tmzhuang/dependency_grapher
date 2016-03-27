require 'yaml'
require 'set'
require_relative 'serialize_helpers'

module DependencyGrapher
  class Method
    attr_reader :defined_class, :method_id
    attr_accessor :types
    include DependencyGrapher::SerializeHelpers
    Limit = 50

    def initialize(defined_class, method_id)
      # Truncate class name to limit characters if too lon
      defined_class = defined_class[0,Limit] + "..." if defined_class.length > Limit
      @defined_class = defined_class
      @method_id = method_id
      @types = Set.new
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

    def full_method_id
      @defined_class + @method_id
    end
  end
end

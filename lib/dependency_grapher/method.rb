require 'yaml'
require 'set'
require_relative 'serialize_helpers'

module DependencyGrapher
  class Method
    include DependencyGrapher::SerializeHelpers

    Limit = 50

    attr_reader :defined_class, :method_id, :path, :lineno
    attr_accessor :types

    def initialize(defined_class, method_id, path, lineno, anon)
      # Truncate class name to limit characters if too long
      defined_class = defined_class[0,Limit] + "..." if defined_class.length > Limit
      @defined_class = defined_class
      @method_id = method_id
      @path = path
      @lineno = lineno
      @anon = anon
      @types = Set.new
    end

    def full_path
      @path + ":" + @lineno
    end

    def anonymous?
      @anon
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

    def full_id
      @defined_class + @method_id
    end
  end
end

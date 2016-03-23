require 'graphviz'

module DependencyGrapher
  class Grapher
    attr_accessor :graph
    def initialize(name = "dependencies")
      @name = name
    end

    # Output dependencies to specified format
    def dump(format = :dot, name = @name)
      # Generate graph
      @graph.output( format => "#{name}.#{format.to_s}")
    end

    # Create graph from loaded dot file
    def load(name = @name)
      @graph = GraphViz.parse("dependencies.dot", path: "./")
    end
  end
end

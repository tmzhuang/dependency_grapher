module DependencyGrapher
	require 'graphviz'
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
    def load_dot(name = @name)
      p "in load dot, loading #{name}.dot"
      @graph = GraphViz.parse("dependencies.dot", path: "./")
    end
  end
end

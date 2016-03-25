require 'graphviz'
require 'set'
require_relative 'grapher'

module DependencyGrapher
  class DotGenerator
    def initialize(dependencies)
      @dependencies = dependencies
      generate_graph_from_dependencies

      grapher = Grapher.new
      grapher.graph = @graph
      #grapher.dump
      #grapher.load_dot
      grapher.dump(:png)
    end

    def generate_graph_from_dependencies
      # Initialize a directional graph
      @graph = GraphViz.digraph( :G, type: :digraph)

      # Create sets to hold edges and methods
      edges ||= Set.new
      methods ||= Set.new

      # Iterate through dependency set to get edges and methods
      @dependencies.each do |dependency|
        # Methods from the dependencies
        caller = dependency.caller
        receiver = dependency.receiver
        # Add methods to set
        methods << caller
        methods << receiver
        # Add edges to set
        edges << { from: caller.method_id, to: receiver.method_id }
      end

      # Iterate over methods to create clusters and nodes
      methods.each do |method|
        add_to_graph(method)
      end

      # Iterate over edges and add them to graph
      edges.each do |edge|
        @graph.add_edges(edge[:from], edge[:to])
      end
    end

    private

    # Add a method to the structure of stored graph. Defined classes are stored
    # as clusters (subgraphs) and method id is used to identify the node
    def add_to_graph(method)
      # Iterate over ancestors (eg. Minitest::Unit yields Minitest, # Unit)
      # This variable is used to reference the immediate parent of the 
      # current graph. Initializes to the root; updates on each iteration.
      prev_graph = @graph 
      method.ancestors.each_with_index do |klass, i|
        graph_id = "cluster_" + method.ancestors[0..i].join("::")
        # Try to find the subgraph if it exists
        if subgraph = prev_graph.get_graph(graph_id)
        else
          # Otherwise we create and label it
          subgraph = prev_graph.add_graph(graph_id)
          subgraph[:label] = klass
        end
        # Update parent
        prev_graph = subgraph
      end
      prev_graph.add_nodes(method.method_id)
    end
  end
end

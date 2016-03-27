require 'graphviz'
require 'set'

module DependencyGrapher
  class Grapher
    def initialize(dependencies)
      @dependencies = dependencies
      generate_graph_from_dependencies
      @graph.output(png: "dependencies.png")
    end

    def output(format = {png: "dependencies.png"})
    end

    def generate_graph_from_dependencies
      # Initialize a directional graph
      @graph = GraphViz.digraph( :G, type: :digraph)

      # Iterate through dependency set to get edges and methods
      @dependencies.each do |dependency|
        # Methods from the dependencies
        caller = dependency.caller
        receiver = dependency.receiver
        # Add edges to set
        #@graph.add_edges(caller.method_id, receiver.method_id, color: :red)
        add_node(caller)
        add_node(receiver)
        add_edge(caller, receiver)
      end
    end

    def add_edge(caller, receiver, color = :black)
      @graph.add_edges(caller.full_method_id, receiver.full_method_id, color: color)
    end

    # Add a method to the structure of stored graph. Defined classes are stored
    # as clusters (subgraphs) and method id is used to identify the node
    def add_node(method)
      #cluster_options = { bgcolor: :darkorchid
      #} 
      # Iterate over ancestors (eg. Minitest::Unit yields Minitest, # Unit)
      # This variable is used to reference the immediate parent of the 
      # current graph. Initializes to the root; updates on each iteration.
      prev_graph = @graph 
      method.ancestors.each_with_index do |klass, i|
        graph_id = "cluster_" + method.ancestors[0..i].join("_")
        # Try to find the subgraph if it exists
        if subgraph = prev_graph.get_graph(graph_id)
        else
          # Otherwise we create and label it
          subgraph = prev_graph.add_graph(graph_id, cluster_options)
          subgraph[:label] = klass
        end
        # Update parent
        prev_graph = subgraph
      end
      options = {}
      options[:label] = method.method_id
      prev_graph.add_nodes(method.full_method_id, options)
    end
  end
end

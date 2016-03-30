require 'graphviz'
require 'set'

module DependencyGrapher
  class Grapher
    def initialize(dependencies)
      @dependencies = dependencies
      generate_graph_from_dependencies
    end

    def output(format)
      @graph.output(format)
    end

    def generate_graph_from_dependencies
      # Initialize a directional graph
      @graph = GraphViz.digraph( :G, type: :digraph, tooltip: " ")

      # Iterate through dependency set to get edges and methods
      @dependencies.each do |dependency|
        # Methods from the dependencies
        kaller = dependency.kaller
        receiver = dependency.receiver
        # Add edges to set
        #@graph.add_edges(kaller.method_id, receiver.method_id, color: :red)
        add_node(kaller)
        add_node(receiver)
        add_edge(dependency)
      end
    end

    def add_edge(dependency)
      options =  {}
      normal_color = get_normal_color(dependency.count)
      options[:color] = dependency.flags.include?(:violation) ? :red : normal_color
      options[:label] = dependency.count > 1 ? dependency.count : ""
      @graph.add_edges(dependency.kaller.full_id, dependency.receiver.full_id, options)
    end

    def get_normal_color(count)
      code = 80 - count * 5
      binding.pry if code < 0
      code = 0 if code < 0
      "gray#{code}"
    end

    # Add a method to the structure of stored graph. Defined classes are stored
    # as clusters (subgraphs) and method id is used to identify the node
    def add_node(method)
      graph = create_clusters(method)
      # Node
      options = {}
      options[:label] = method.method_id
      options[:tooltip] = method.full_path
      graph.add_nodes(method.full_id, options)
    end

    def create_clusters(method)
      cluster_options = {tooltip: " "}
      if method.types.include?(:service)
        cluster_options[:bgcolor] = :azure3
      elsif method.types.include?(:framework)
        cluster_options[:bgcolor] = :brown
      end

      # Iterate over ancestors (eg. Minitest::Unit yields Minitest, # Unit)
      # This variable is used to reference the immediate parent of the 
      # current graph. Initializes to the root; updates on each iteration.
      prev_graph = @graph 
      method.ancestors.each_with_index do |klass, i|
        # Prepending "cluster_" is mandatory according to ruby-graphviz API
        graph_id = "cluster_" + method.ancestors[0..i].join("_")
        # add_graph returns an existing graph if it exists
        subgraph = prev_graph.add_graph(graph_id, cluster_options)
        subgraph[:label] = klass
        # Update parent for next iteration
        prev_graph = subgraph
      end
      prev_graph
    end
  end
end

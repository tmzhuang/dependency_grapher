module DependencyGrapher
	require 'graphviz'
	class Grapher
    def initialize(dependencies)
      @analyzer = Analyzer.new(dependencies)
      @dependencies = dependencies
    end

		def graph
      @graph = GraphViz.digraph( :G, type: :digraph)
      @clusters = []
      @dependencies.each do |dependency|
        # Methods from the dependencies
        caller = dependency.caller
        receiver = dependency.receiver
        # Create clusters
        create_clusters_from(caller.defined_class)
        create_clusters_from(receiver.defined_class)
        # Create nodes
        create_node_from(caller)
        create_node_from(receiver)
        # Create edge
        #calling_node = caller.method_id.to_s
        #receiving_node = caller.method_id.to_s
        #@graph.add_edges(calling_node, receiving_node)
      end

      # Generate graph
      graph.output( png: "graph.png")
		end

    private
    # Given a Class object, returns an array with each subclass as a string element
    # Ex. Minitest::Test => ["Minitest", "Test"]
    def class_to_a(klass)
      klass.to_s.split("::")
    end

    # Given a method, adds it to the cluster its class belongs to
    def create_node_from(method)
      classes = class_to_a(method.defined_class)
      depth = classes.size - 1
      klass = classes.last
      cluster = @clusters[depth][klass]
      cluster.add_nodes(method.method_id.to_s)
    end

    # Given an array of classes, creates clusters from the array
    def create_clusters_from(klass)
      # Split classes into an array 
      classes = class_to_a(klass)
      # Iterate over array and add each element as a subgraph at corresponding depth
      classes.each_with_index do |klass, i|
        @clusters[i] ||= {} 
        curr_class = classes[i]
        if i == 0
          # If we're at the root, add the cluster to the graph
          subgraph = @graph.add_graph("cluster_" + curr_class)
          #puts "here is the subgraph: #{subgraph}"
          #puts "putting it into @clusters[#{i}][#{curr_class}]"
          @clusters[i][curr_class] = subgraph
          #puts "here it is from the clusters: #{@clusters[i][curr_class]}"
          #c = (subgraph == @clusters[i][curr_class])
          #puts "are they equal? #{c}"
        else
          #Otherwise add it as a subgraph of the previous class
          prev_class = classes[i-1]
          @clusters[i][curr_class] = @clusters[i-1][prev_class].add_graph("cluster_" + curr_class)
        end
        # Label current graph
        @clusters[i][curr_class][:label] = curr_class
      end
    end
  end
end

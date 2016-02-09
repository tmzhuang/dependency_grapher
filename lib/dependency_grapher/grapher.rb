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
        caller = dependency.caller
        receiver = dependency.receiver
        # Array containing name of classes
        # ex. ["Minitest", "Test"]
        caller_classes = class_to_a(caller.defined_class)
        receiver_classes = class_to_a(receiver.defined_class)
        # Create clusters
        create_clusters_from(caller_classes)
        create_clusters_from(receiver_classes)
        # Create nodes
        calling_node = create_node_from(caller.method_id)
        receiving_node = create_node_from(receiver.method_id)
        # Create edge
        @graph.add_edges(calling_node, receiving_node)
      end

      # Generate graph
      graph.output( png: "graph.png")
		end

    private
    # Given a Class object, returns an array with each subclass as a string element
    # Ex. Minitest::Test => ["Minitest", "Test"]
    def class_to_a(klass)
      klass.inspect.split("::")
    end

    # Given a depth and class_name, returns the subgraph from the @clusters
    # instance variable at that location
    def get_cluster(depth, class_name)
      @cluster[depth][class_name]
    end

    # Given a method, adds it to the cluster its class belongs to
    def create_node_from(method)
      classes = class_to_a(method.defined_class)
      cluster = get_cluster(classes.size - 1, classes.last)
      cluster.add_nodes(method.method_id.inspect)
    end

    # Given an array of classes, creates clusters from the array
    def create_clusters_from(classes)
      classes.each_with_index do |klass, i|
        @clusters[i] = {} unless @clusters[i]
        curr_class = classes[i].inspect
        prev_class = classes[i-1].inspect if i > 0

        if i == 0
          # If we're at the root, add the cluster to the graph
          @clusters[i][curr_class] = @graph.add_graph("cluster_" + curr_class)
        else
          #Otherwise add it as a subgraph of the previous class
          @clusters[i][curr_class] = @clusters[i-1][prev_class].add_graph("cluster_" + curr_class)
        end
        # Label current graph
        @clusters[i][curr_class][:label] = curr_class
      end
    end
  end
end

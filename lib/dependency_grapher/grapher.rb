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
        ##p "Okay wtf is going on.."
        #p "caller class is #{caller.defined_class}"
        #p "\tas an array it is #{caller.defined_class.to_s.split("::")}"
        # Array containing name of classes
        # ex. ["Minitest", "Test"]
        caller_classes = class_to_a(caller.defined_class)
        receiver_classes = class_to_a(receiver.defined_class)
        # Create clusters
        #p "Creating caller classes: #{caller_classes}"
        create_clusters_from(caller_classes)
        #p "Creating receiver classes: #{receiver_classes}"
        create_clusters_from(receiver_classes)
        # Create nodes
        calling_node = create_node_from(caller)
        receiving_node = create_node_from(receiver)
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
      klass.to_s.split("::")
    end

    # Given a depth and class_name, returns the subgraph from the @clusters
    # instance variable at that location
    def get_cluster(depth, class_name)
      #p "clusters[#{depth}][#{class_name}] #{@clusters[depth][class_name]}"
      @clusters[depth][class_name]
    end

    # Given a method, adds it to the cluster its class belongs to
    def create_node_from(method)
      classes = class_to_a(method.defined_class)
      cluster = get_cluster(classes.size - 1, classes.last)
      #p "Cluster: #{cluster}"
      cluster.add_nodes(method.method_id.to_s)
      ;
    end

    # Given an array of classes, creates clusters from the array
    def create_clusters_from(classes)
      classes.each_with_index do |klass, i|
        @clusters[i] = {} unless @clusters[i]
        curr_class = classes[i].to_s
        #p "curr_class #{ curr_class }"
        if i == 0
          # If we're at the root, add the cluster to the graph
          subgraph = @graph.add_graph("cluster_" + curr_class)
          puts "here is the subgraph: #{subgraph}"
          puts "putting it into @clusters[#{i}][#{curr_class}]"
          @clusters[i][curr_class] = subgraph
          puts "here it is from the clusters: #{@clusters[i][curr_class]}"
          c = (subgraph == @clusters[i][curr_class])
          puts "are they equal? #{c}"
        else
          #Otherwise add it as a subgraph of the previous class
          prev_class = classes[i-1].to_s 
          @clusters[i][curr_class] = @clusters[i-1][prev_class].add_graph("cluster_" + curr_class)
          #p "prev_class #{ prev_class }"
        end
        # Label current graph
        @clusters[i][curr_class][:label] = curr_class
      end
    end
  end
end

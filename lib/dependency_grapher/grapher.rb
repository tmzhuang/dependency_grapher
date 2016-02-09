module DependencyGrapher
	require 'graphviz'
	class Grapher
    def initialize(dependencies)
      @analyzer = Analyzer.new(dependencies)
      p dependencies
    end

		def graph
			## Initialize digraph
			#graph = GraphViz.digraph( :G, type: :digraph)
			#clusters = {}
			## Create clusters
			#@clusters.each do |aclass|
				#clusters[aclass] = graph.add_graph("cluster_" + aclass.to_s)
				#clusters[aclass][:label] = aclass.to_s
			#end

			##Add nodes and edges
			#@dependencies.each do |dependency| 
				#dependency.each do |acaller, acallee|
					#calling_method_name = acaller[:method].inspect
					#callee_method_name = acallee[:method].inspect
					#clusters[acaller[:class]].add_nodes(calling_method_name)
					#clusters[acallee[:class]].add_nodes(callee_method_name)
					#graph.add_edges(calling_method_name, callee_method_name)
				#end
			#end 
			## Generate graph
			#graph.output( png: "graph.png")
		end

    private
    # Create graph and clusters as subgraphs
    def create_graphs
    end

    end
	end
end

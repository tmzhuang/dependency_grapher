module DependencyGrapher
	require 'graphviz'
	class Analyzer
		def initialize(dependencies, clusters)
			@dependencies = dependencies
			@clusters = clusters

			@controllers = classes_in("controllers")
			@models = classes_in("models")
			@services = classes_in("services")
		end


		# Returns an array of class names in folder specified by argument. Since we are dealing 
		end


		# Returns an array of class names in folder specified by argument. Since we are dealing 
		# with a Rails app, folder is expected to be in app/. For example, if folder is specified
		# to be 'models', then classes in 'app/models/' will be returned.
		def classes_in(folder)
			result = []
			Dir.glob("app/#{folder}/*.rb").map do |file|
				result << file[/app\/#{folder}\/(.*)\.rb/, 1].camelize
			end
		end

		def apply_filter(*filters)
			if filters.size > 1
				filters.map(&:apply_filter)
				filters.each do |filter|
					apply_filter(filter)
				end
			else
				case filters.first
				when :interclass
				when :rails
				end
			end
		end
		
		def remove_filter(*filters)
		end

		def calc_filter_set(filter)
		end

		def graph
			# Initialize digraph
			graph = GraphViz.digraph( :G, type: :digraph)
			clusters = {}
			# Create clusters
			@clusters.each do |aclass|
				clusters[aclass] = graph.add_graph("cluster_" + aclass.to_s)
				clusters[aclass][:label] = aclass.to_s
			end
			#Add nodes and edges
			@dependencies.each do |dependency| 
				dependency.each do |acaller, acallee|
					calling_method_name = acaller[:method].inspect
					callee_method_name = acallee[:method].inspect
					clusters[acaller[:class]].add_nodes(calling_method_name)
					clusters[acallee[:class]].add_nodes(callee_method_name)
					graph.add_edges(calling_method_name, callee_method_name)
				end
			end 
			# Generate graph
			graph.output( png: "graph.png")
		end
	end
end

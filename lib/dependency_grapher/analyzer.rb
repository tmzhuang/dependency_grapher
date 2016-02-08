module DependencyGrapher
	require 'set'
	class Analyzer
		def initialize(dependencies, *filters)
			@dependencies = dependencies

      # Crawl folders for class names 
			@controllers = classes_in("controllers")
			@models = classes_in("models")
			@services = classes_in("services")

      # Add default filters
			if filters.empty?
        add_filters(:interclass, :rails)
      # Otherwise, add provided filters
      else
        add_filters(filters)
      end

      #Apply filters
      apply_filters
		end

		def add_filters(*filters)
      @filters.merge filters
		end

		def remove_filters(*filters)
		end

    def apply_filters
      @filters.each do |filter|
        case filter
        when :intercluster
        when :rails
      end
    end

    def calc_dependencies
    end

    private
		# Returns an array of class names in folder specified by argument. Since we are dealing 
		# with a Rails app, folder is expected to be in app/. For example, if folder is specified
		# to be 'models', then classes in 'app/models/' will be returned.
		def classes_in(folder)
			result = []
			Dir.glob("app/#{folder}/*.rb").map do |file|
				result << file[/app\/#{folder}\/(.*)\.rb/, 1].camelize
			end
		end
		
		def calc_filter_set(filter)
		end

	end
end

namespace :dep do
  desc 'Outputs dependencies to graph given format. Defaults to dot.'
  task :graph, :name, :format do |t, args|
    format = args[:format] || :dot
    name = args[:name] || "dependencies"
    #dependencies = @@dependency_logger.dependencies
    # Pass logged dependencies to filter
    filter = DependencyGrapher::Filter.new
    filter.load_file
    filter.filter
    grapher = DependencyGrapher::Grapher.new(filter.dependencies)
    #grapher.output
    ## Pass filtered dependnecies to dot generator (creates dot file on initialization)
    #DependencyGrapher::Grapher.new(filtered_dependencies)
  end
  
  desc 'List known classes in project from autoload_paths'
  task :known do
    classes = DependencyGrapher::GetKnownClasses.call
    classes.each do |klass|
      p klass
    end
  end

  desc 'List known classes in app/services'
  task :services do
    classes = DependencyGrapher::GetServiceClasses.call
    classes.each do |klass|
      p klass
    end
  end
end

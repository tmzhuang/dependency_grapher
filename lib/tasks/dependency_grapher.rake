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
    analyzer = DependencyGrapher::Analyzer.new(filter.dependencies)
    analyzer.set_frameworks
    analyzer.set_violations
    grapher = DependencyGrapher::Grapher.new(analyzer.dependencies)
    #grapher.output
    ## Pass filtered dependnecies to dot generator (creates dot file on initialization)
    #DependencyGrapher::Grapher.new(filtered_dependencies)
  end

  namespace :list do
    desc 'List known classes in project from autoload_paths'
    task :all do
      classes = DependencyGrapher::GetKnownClasses.call
      classes.each do |klass|
        p klass
      end
    end

    desc 'List known classes in app/services'
    task :services do
      classes = DependencyGrapher::GetKnownClasses.call(:services)
      classes.each do |klass|
        p klass
      end
    end

    desc 'List known classes in app/controllers'
    task :controllers do
      classes = DependencyGrapher::GetKnownClasses.call(:controllers)
      classes.each do |klass|
        p klass
      end
    end
  end
end

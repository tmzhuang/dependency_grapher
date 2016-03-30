namespace :dep do
  desc 'Outputs dependencies to graph given format. Defaults to dot.'
  task :graph, [:name] do |t, args|
    name = args[:name] || "dependencies.svg"

    format = name[/^.*\.(\w*)$/, 1].to_sym
    
    # Remove Rails classes, self-calls, and inter-class calls
    filter = DependencyGrapher::Filter.new
    filter.load_file
    filter.filter

    # Tag methods in dependcies as
    analyzer = DependencyGrapher::Analyzer.new(filter.dependencies)
    analyzer.set_method_types
    analyzer.set_dependency_flags

    grapher = DependencyGrapher::Grapher.new(analyzer.dependencies)
    grapher.output(format => name)
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

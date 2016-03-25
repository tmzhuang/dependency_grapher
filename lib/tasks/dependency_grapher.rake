require_relative '../dependency_grapher/get_known_classes'
namespace :depg do
  desc 'Outputs dependencies to graph given format. Defaults to dot.'
  task :graph, :name, :format do |t, args|
    format = args[:format] || :dot
    name = args[:name] || "dependencies"
    grapher = DependencyGrapher::Grapher.new(name)
    grapher.load_dot
    grapher.dump
  end
  
  desc 'List known classes in project from autoload_paths'
  task :classes do
    classes = DependencyGrapher::GetKnownClasses.call
  end
end

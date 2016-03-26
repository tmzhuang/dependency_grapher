require "dependency_grapher/version"

module DependencyGrapher
  Gem.find_files("dependency_grapher/*.rb").each do |path|
    require path
  end
	require 'dependency_grapher/railtie' if defined?(Rails)
end

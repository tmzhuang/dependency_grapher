module DependencyGrapher
  require "dependency_grapher/version"
	require 'dependency_grapher/logger'
	require 'dependency_grapher/filter'
	require 'dependency_grapher/analyzer'
	require 'dependency_grapher/grapher'
	require 'dependency_grapher/get_known_classes'
	require 'dependency_grapher/test_helpers'
	require 'dependency_grapher/railtie' if defined?(Rails)
end

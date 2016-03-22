module DependencyGrapher
  require 'active_support'
  require 'minitest'
  require 'yaml'
  require_relative "dependency_filter"
  require_relative "dot_generator"
  module TestHelpers
    extend ActiveSupport::Concern
    included do
      @@dependency_logger = DependencyGrapher::Logger.new

      setup do
        @@dependency_logger.enable
      end

      teardown do
        @@dependency_logger.disable
      end

      Minitest.after_run do 
        dependencies = @@dependency_logger.dependencies
        # Pass logged dependencies to filter
        filtered_dependencies = DependencyGrapher::DependencyFilter.new(dependencies).dependencies
        # Pass filtered dependnecies to dot generator (creates dot file on initialization)
        dot_generator = DependencyGrapher::DotGenerator.new(filtered_dependencies)
      end
    end
  end

end

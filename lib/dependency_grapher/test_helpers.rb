require 'active_support'
require 'minitest'
require_relative "dependency_filter"
require_relative "dot_generator"

module DependencyGrapher
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
        DependencyGrapher::DotGenerator.new(filtered_dependencies)
      end
    end
  end
end

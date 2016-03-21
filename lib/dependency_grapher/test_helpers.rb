module DependencyGrapher
  require 'active_support'
  require 'minitest'
  module TestHelpers
    extend ActiveSupport::Concern

    included do
      ## Add more helper methods to be used by all tests here...
      @@dependency_logger = DependencyGrapher::Logger.new

      setup do
        @@dependency_logger.enable
      end

      teardown do
        @@dependency_logger.disable
      end

      Minitest.after_run do 
        #analyzer = DependencyGrapher::Analyzer.new(@@dependency_logger.dependencies)
        grapher = DependencyGrapher::Grapher.new(@@dependency_logger.dependencies)
        grapher.graph
      end
    end
  end

end

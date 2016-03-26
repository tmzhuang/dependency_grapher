require 'active_support'

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
        @@dependency_logger.dump
      end
    end
  end
end

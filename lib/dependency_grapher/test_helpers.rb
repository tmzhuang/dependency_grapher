require 'active_support'
require 'minitest'
require 'pry'
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
        @@dependency_logger.dump
      end
    end
  end
end

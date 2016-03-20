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
        p "From minitest:DG"
        p @dependency_logger
      end

      #Minitest.after_run do
      #puts
      #puts "-----------------------------------------"
      #puts "Timing Information for the Last Test Run"
      #puts "-----------------------------------------"
      #puts
      #puts "Time, Test Name"
      #puts
      #@@minitest_profiler_report.sort_by { |timing| timing[:time] }.reverse.each { |timing| puts "#{timing[:time]}, #{timing[:name]}" }
      #end
    end
  end

end

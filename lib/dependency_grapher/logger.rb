require_relative "method"
require_relative "dependency"

module DependencyGrapher
	class Logger
		attr_reader :dependencies 

		def initialize
      # This set has all dependencies logged. There will many
			@dependencies = Set.new
		end

		def enable
      # Call stack for tracking method calls
			@call_stack = []
      # Define a tracepoint for tacking ruby calls and returns
			@trace = TracePoint.trace(:call, :return) do |tp|
				case tp.event
				when :call
          @call_stack << Method.new(tp.defined_class, tp.method_id) 
				when :return
					# When function returns, add dependency to 
					# @dependencies as the current returning method
					# with the last item on the stack
					caller = @call_stack[-2] # Second last item on stack is the caller
					receiver = @call_stack.pop # First item on stack is receiver
          # Ignore case where caller is nil (ie. main)
          @dependencies << Dependency.new(caller, receiver) if caller 
				end
			end
      # This should be called within the test frame work in the setup function
      # The TestHelpers modules takes care of this; see readme for installation
      # instructions
      @trace.enable
		end

		def disable
      # Called in teardown
			@trace.disable
		end
	end
end

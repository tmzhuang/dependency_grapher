require_relative "method"
require_relative "dependency"
require_relative "parse_class"
require 'pry'
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
          name = ParseClass.call(tp.defined_class)
          @call_stack << Method.new(name, tp.method_id.to_s) 
				when :return
					# When function returns, add dependency to 
					# @dependencies as the current returning method
					# with the last item on the stack
          kaller = @call_stack[-2] # Second last item on stack is the kaller
          receiver = @call_stack.pop # First item on stack is receiver
          # Ignore case where kaller is nil (ie. main)
          @dependencies << Dependency.new(kaller, receiver) if kaller
				end
			end
      @trace.enable
		end

		def disable
      # Called in teardown
			@trace.disable
		end

    # STRING, STRING -> post
    # post: 
    def push_call(defined_class, method)
    end
	end
end

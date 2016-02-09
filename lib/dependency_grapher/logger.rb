module DependencyGrapher
	class Logger
		attr_reader :dependencies 

		def initialize
			# Set of all inter-class method calls
			@dependencies ||= Set.new
		end

		def enable
			@call_stack = []
			@trace = TracePoint.trace(:call, :return) do |tp|
				case tp.event
				when :call
					# Push calls onto stack
					@call_stack << DependencyGrapher::Method.new(tp.defined_class, tp.method_id) 
				when :return
					# When function returns, add dependency to 
					# @dependencies as the current returning method
					# with the last item on the stack
					caller = @call_stack[-1]
					receiver = @call_stack.pop
					# my_caller should be nil when returning from main,
					# so ignore that. Otherwise, we also don't care about
					# dependencies within classes
          @dependencies << Dependency.new(caller, receiver) if caller
				end
			end
		end

		def disable
			@trace.disable
		end
	end
end

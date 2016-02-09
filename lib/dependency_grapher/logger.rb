module DependencyGrapher
	class Logger
		attr_reader :dependencies 

		def initialize
			# Set of all inter-class method calls
			@dependencies ||= Set.new
		end

		def enable
			@call_stack = Array.new
			@trace = TracePoint.trace(:call, :return) do |tp|
				case tp.event
					# Push calls onto stack
				when :call
					@call_stack <<  Method.new(tp.defined_class, tp.method_id) 
					# When function returns, add dependency to 
					# @dependencies as the current returning method
					# with the last item on the stack
				when :return
					caller = @call_stack[-1]
					receiver = @call_stack.pop
					# my_caller should be nil when returning from main,
					# so ignore that. Otherwise, we also don't care about
					# dependencies within classes
					if caller
						@dependencies << Dependency.new(caller, receiver)
					end
				end
			end
		end

		def disable
			@trace.disable
		end
	end
end

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
					call = { class: tp.defined_class, method: tp.method_id }
					@call_stack << call
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
						dependency = { caller: caller, receiver: receiver }
						@dependencies << dependency
					end
				end
			end
		end

		def disable
			@trace.disable
		end
	end
end

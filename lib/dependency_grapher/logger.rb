module RubyDependencyGrapher
	class Logger
		attr_reader :dependencies, :clusters

		def initialize
			# Set of all known clases 
			@clusters ||= Set.new
			# Set of all inter-class method calls
			@dependencies ||= Set.new
		end

		def enable
			@call_stack = Array.new
			@trace = TracePoint.trace(:call, :return) do |tp|
				case tp.event
					# Push calls onto stack
				when :call
					item = {
						class: tp.defined_class, 
						method: tp.method_id }
					@call_stack << item
					# When function returns, add dependency to 
					# @dependencies as the current returning method
					# with the last item on the stack
				when :return
					my_callee = @call_stack.pop
					my_caller = @call_stack[-1]
					# my_caller should be nil when returning from main,
					# so ignore that. Otherwise, we also don't care about
					# dependencies within classes
					if my_caller != nil and my_caller[:class] != my_callee[:class]
						dependency = {my_caller => my_callee}
						@dependencies << dependency
						@clusters << my_caller[:class]
						@clusters << my_callee[:class]
					end
				end
			end
		end

		def disable
			@trace.disable
		end
	end
end

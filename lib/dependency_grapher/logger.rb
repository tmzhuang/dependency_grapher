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
      # Call stack for tracking method calls
			@call_stack = []
      @trace = get_trace_point
		end

		def enable
      @trace.enable
		end

		def disable
			@trace.disable
		end

    def dump
      file = File.open("dependencies.yml", "w")
      @dependencies.each do |dep|
        file.puts dep.serialize
        file.puts
      end
    end

    private
    def get_trace_point
      # Define a tracepoint for tacking ruby calls and returns
			tp = TracePoint.trace(:call, :return) do |tp|
				case tp.event
				when :call
          handle_call(tp.defined_class, tp.method_id)
				when :return
          handle_return
				end
			end
      tp.disable # Disable tp by default
      tp
    end

    def handle_call(defined_class, method_id)
      @call_stack << Method.new(ParseClass.call(defined_class), method_id.to_s) 
    end

    def handle_return
      kaller = @call_stack[-2] # Second last item on stack is the kaller
      receiver = @call_stack.pop # First item on stack is receiver
      # Ignore case where kaller is nil (ie. main)
      @dependencies << Dependency.new(kaller, receiver) if kaller
    end
	end
end

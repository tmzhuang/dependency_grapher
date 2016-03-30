require_relative "method"
require_relative "dependency"
require_relative "parse_class"

require 'pry'
module DependencyGrapher
  class Logger
    attr_reader :dependencies 
    def initialize
      @dependencies = {}
      @keys = Set.new
      @call_stack = []
      @methods = {}
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
      @keys.each do |key|
        file.puts @dependencies[key].serialize
        file.puts
      end
    end

    private
    def get_trace_point
      # Define a tracepoint for tacking ruby calls and returns
      tp = TracePoint.trace(:call, :return) do |tp|
        case tp.event
        when :call
          handle_call(tp.defined_class, tp.method_id, tp.path, tp.lineno, tp.defined_class.anonymous?)
        when :return
          handle_return
        end
      end
      tp.disable # Disable tp by default
      tp
    end

    def handle_call(defined_class, method_id, path, lineno, anon)
      method = Method.new(ParseClass.call(defined_class), method_id.to_s, path, lineno.to_s, anon) 
      @methods[method.full_id] = method unless  @methods[method.full_id]
      @call_stack <<  @methods[method.full_id]
    end

    def handle_return
      kaller = @call_stack[-2] # Second last item on stack is the kaller
      receiver = @call_stack.pop # First item on stack is receiver
      # Ignore case where kaller is nil (ie. main)
      if kaller
        dep = Dependency.new(kaller, receiver)
        key = dep.full_id
        if @keys.include?(key)
          @dependencies[key].touch
        else
          @dependencies[key] = dep
          @keys << key
        end
      end
    end
  end
end

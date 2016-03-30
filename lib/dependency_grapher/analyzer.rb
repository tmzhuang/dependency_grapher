require 'set'

module DependencyGrapher
  class Analyzer
    attr_accessor :dependencies

    def initialize(dependencies = nil)
      @dependencies = dependencies
    end

    def load_dependencies(dependencies)
      @dependencies = dependencies
    end

    def set_dependency_flags
      @dependencies.each do |dep|
        if dep.receiver.types.include?(:framework)
          dep.flags << :violation unless dep.kaller.types.include?(:service)
        end
      end
    end

    # OPTIMIZE
    def set_method_types
      services = GetKnownClasses.call(:services)
      framework_roots = Set.new
      # Marks all receiver of service objects as :framework
      @dependencies.each do |dep|
        if services.include?(dep.kaller.root)
          dep.kaller.types << :service
          dep.receiver.types << :framework
          framework_roots << dep.receiver.root
        end
      end
      
      # Marks all methods with a root that is shared with 
      # methods in the frameworks list as :framework
      @dependencies.each do |dep|
        if framework_roots.include?(dep.kaller.root)
          dep.kaller.types << :framework
        elsif framework_roots.include?(dep.receiver.root)
          dep.receiver.types << :framework
        end
      end
    end
  end
end

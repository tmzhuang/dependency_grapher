require 'set'
require_relative 'deserialize_dependencies'

module DependencyGrapher
  class Filter
    attr_accessor :dependencies
    def initialize
      @dependencies = nil
    end

    def filter
      tmp_deps = Set.new
      receiver = {}

      # Crawl ActiveSupport::Dependencies.autoload_paths for known classes
      known_classes = GetKnownClasses.call

      @dependencies.each_with_index do |dep, i|
        kaller = dep.kaller
        receiver = dep.receiver
        # all pass_conds must be true for dependency to be added to calculated_dependencies
        pass_conds = true
        pass_conds &&= kaller.id != receiver.id
        pass_conds &&= (known_classes.include?(kaller.root) || known_classes.include?(receiver.root))
        tmp_deps << dep if pass_conds
      end

      @dependencies = tmp_deps
    end

    def load_file(filename = "dependencies.yml")
      @dependencies = DeserializeDependencies.call(filename)
    end

    def load_dependencies(dependencies)
      @dependencies = dependencies
    end
  end
end

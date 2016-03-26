require 'set'

module DependencyGrapher
  class Filter
    attr_accessor :dependencies
    def initialize
      @dependencies = nil
    end

    def filter
      tmp_deps = Set.new

      # Crawl ActiveSupport::Dependencies.autoload_paths for known classes
      known_classes = GetKnownClasses.call

      @dependencies.each_with_index do |dep, i|
        kaller = dep.caller
        receiver = dep.receiver
        # all pass_conds must be true for dependency to be added to calculated_dependencies
        pass_conds = true
        pass_conds &&= kaller.full_method_id != receiver.full_method_id
        pass_conds &&= (known_classes.include?(kaller.root) || known_classes.include?(receiver.root))
        tmp_deps << dep if pass_conds
      end

      @dependencies = tmp_deps
    end

    def load_file(yaml_file = "dependencies.yml")
      @dependencies = Set.new
      $/="\n\n"
      File.open(yaml_file, "r").each do |object|
        @dependencies << Dependency.deserialize(object)
      end
    end
  end
end

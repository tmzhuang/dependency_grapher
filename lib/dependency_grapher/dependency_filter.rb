require 'set'

module DependencyGrapher
  class DependencyFilter
    def initialize(dependencies, *filters)
      @original_dependencies = dependencies
      @calculated_dependencies = Set.new

      # Crawl ActiveSupport::Dependencies.autoload_paths for known classes
      @known_classes = GetKnownClasses.call

      @original_dependencies.each_with_index do |dep, i|
        kaller = dep.caller
        receiver = dep.receiver
        # all pass_conds must be true for dependency to be added to calculated_dependencies
        pass_conds = true
        pass_conds &&= kaller.root != receiver.root
        pass_conds &&= (@known_classes.include?(kaller.root) || @known_classes.include?(receiver.root))
        @calculated_dependencies << dep if pass_conds
      end

      #Add default filters
      #if filters.empty?
        #@filters = Set.new [:interclass, :rails]
        ## Otherwise, add provided filters
      #else
        #add_filters(filters)
      #end

      ##Apply filters
      #apply_filters
    end

    def add_filters(*filters)
      @filters.merge filters
    end

    def remove_filters(*filters)
    end

    def apply_filters
      @filters.each do |filter|
        apply_filter(filter)
      end
    end

    def dependencies
      @calculated_dependencies
    end

    private
    # Returns an array of class names in folder specified by argument. Since we are dealing 
    # with a Rails app, folder is expected to be in app/. For example, if folder is specified
    # to be 'models', then classes in 'app/models/' will be returned.
    def apply_filter(filter)
      case filter
      when :interclass
      when :rails
      end
    end
  end
end

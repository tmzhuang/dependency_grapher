module DependencyGrapher
  require 'set'
  class Analyzer
    def initialize(dependencies, *filters)
      @original_dependencies = dependencies
      @calculated_dependencies = Set.new

      # Crawl ActiveSupport::Dependencies.autoload_paths for known classes
      @known_classes = get_classes
      #@known_classes.each do |klass|
        #p klass
      #end

      p @original_dependencies.size
      @original_dependencies.each_with_index do |dep, i|
        caller_root = dep.caller.defined_class.to_s.split("::").first
        receiver_root = dep.receiver.defined_class.to_s.split("::").first
        # all pass_conds must be true for dependency to be added to calculated_dependencies
        pass_conds = true
        #pass_conds &&= caller_root != receiver_root
        #if caller_root == "User"
          #p "caller_root: #{caller_root}"
          #p "receiver_root: #{receiver_root}"
          #p "known? : #{(@known_classes.include?(caller_root) || @known_classes.include?(receiver_root))}"
        #end
        pass_conds &&= (@known_classes.include?(caller_root) || @known_classes.include?(receiver_root))
        @calculated_dependencies << dep if pass_conds
        #@calculated_dependencies << dep 
      end

      #p "cacl dep size: #{@calculated_dependencies.size}"
      @calculated_dependencies.each do |dep|
        p "class #{dep.caller.defined_class.to_s} calling #{dep.receiver.defined_class.to_s}"
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
    def get_classes
      result = Set.new
      ActiveSupport::Dependencies.autoload_paths.each do |folder|
        Dir.glob("#{folder}/*.rb").map do |file|
          result << file[/#{folder}\/(.*)\.rb/, 1].camelize
        end
      end
      result
    end

    def apply_filter(filter)
      case filter
      when :interclass
      when :rails
      end
    end
  end
end

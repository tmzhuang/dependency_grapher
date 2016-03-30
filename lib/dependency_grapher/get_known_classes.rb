require 'set'

module DependencyGrapher
  module GetKnownClasses
    module_function
    def call(folder = nil)
      result = Set.new
      #ActiveSupport::Dependencies.autoload_paths.each do |folder|
      if folder
        full_folder = "app/" + folder.to_s
        result = get_classes_in(full_folder)
      else
        Rails.application.config.eager_load_paths.each do |folder|
          result.merge get_classes_in(folder)
        end
      end
      result
    end

    private_class_method
    def get_classes_in(folder)
      classes = Set.new
      files = File.join("#{folder}", "**", "*.rb")
      Dir.glob(files).map do |file|
        classes << file[/#{folder}\/(.*).rb/,1].camelize
      end
      classes
    end
  end
end

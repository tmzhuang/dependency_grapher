require 'set'

module DependencyGrapher
  class GetKnownClasses
    def self.call(folder = nil)
      result = Set.new
      #ActiveSupport::Dependencies.autoload_paths.each do |folder|
      if folder
        result = get_classes_in(folder)
      else
        Rails.application.config.eager_load_paths.each do |folder|
          result.merge get_classes_in(folder)
        end
      end
      result
    end

    private
    def get_classes_in(folder)
      classes = Set.new
      #files = File.join("#{folder}/*.rb", "#{folder}/**")
      files = File.join("#{folder}", "**", "*.rb")
      Dir.glob(files).map do |file|
        classes << file[/#{folder}\/(.*).rb/,1].camelize
      end
      classes
    end
  end
end

require 'set'

module DependencyGrapher
  class GetKnownClasses
    def self.call
      result = Set.new
      #ActiveSupport::Dependencies.autoload_paths.each do |folder|
      Rails.application.config.eager_load_paths.each do |folder|
        Dir.glob("#{folder}/*.rb").map do |file|
          result << file[/#{folder}\/(.*)\.rb/, 1].camelize
        end
      end
      result
    end
  end
end

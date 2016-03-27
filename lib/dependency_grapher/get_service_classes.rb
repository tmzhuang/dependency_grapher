require 'set'

module DependencyGrapher
  class GetServiceClasses
    def self.call
      result = Set.new
      folder = "app/services"
      #ActiveSupport::Dependencies.autoload_paths.each do |folder|
      Dir.glob("#{folder}/*.rb").map do |file|
        result << file[/#{folder}\/(.*)\.rb/, 1].camelize
      end
      result
    end
  end
end

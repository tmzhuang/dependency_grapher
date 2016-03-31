require 'set'

module DependencyGrapher
  module DeserializeDependencies
    module_function

    # TODO: extract filename defaults to constants
    def call(filename = "dependencies.yml")
      dependencies = Set.new
      $/="\n\n"
      File.open(filename, "r").each do |object|
        begin
          dependencies << Dependency.deserialize(object)
        rescue
          raise $!, "Could not load object from #{filename}", $!.backtrace
        end
      end
      dependencies
    end
  end
end

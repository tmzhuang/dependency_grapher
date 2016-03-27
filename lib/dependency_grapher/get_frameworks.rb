require 'set'

module DependencyGrapher
  class GetFrameworks
    class << self
      def call(dependencies)
        services = GetKnownServices.call(:services)
        # Go through each dependency and makr
        dependencies.each do |dep|
          if services.include(dep.caller)
            dep.receiver.types << :framework
          end
        end
      end
    end
  end
end

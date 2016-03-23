require 'active_support'
require 'yaml'

module DependencyGrapher
  module SerializeHelpers
    extend ActiveSupport::Concern
    included do
      def serialize
        to_yaml
      end

      def self.deserialize(string)
        self.from_yaml(string)
      end

      private
      def to_yaml
        YAML.dump(self)
      end

      def self.from_yaml(yaml_string)
        YAML.load(yaml_string)
      end
    end
  end
end

require 'dependency_grapher'
require 'rails'
module DependencyGrapher
  class Railtie < Rails::Railtie
    railtie_name :dependency_grapher

    rake_tasks do
      load "tasks/dependency_grapher.rake"
    end
  end
end

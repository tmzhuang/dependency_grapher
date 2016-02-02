# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_dependency_grapher/version'

Gem::Specification.new do |spec|
  spec.name          = "rails_dependency_grapher"
  spec.version       = RailsDependencyGrapher::VERSION
  spec.authors       = ["tmzhuang"]
  spec.email         = ["abstract.wolf@gmail.com"]

  spec.summary       = %q{Graphical vizualization of Ruby on Rails application dependencies.}
  spec.description   = %q{For Rails applications that use minitest as the automated test framework. This gem provides a class for logging the dependencies of the application while the test runs, and another for analyzing those dependencies and producing a graph.}
  spec.homepage      = "https://github.com/tmzhuang/rails_dependency_grapher"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  #spec.add_development_dependency "ruby-graphviz", "~> 1.2.2"
  spec.add_runtime_dependency "ruby-graphviz", "~> 1.2.2"
end

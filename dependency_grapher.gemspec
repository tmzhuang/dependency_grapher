# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dependency_grapher/version'

Gem::Specification.new do |spec|
  spec.name          = "dependency_grapher"
  spec.version       = DependencyGrapher::VERSION
  spec.authors       = ["Tianming Zhuang"]
  spec.email         = ["tianming.zhuang@gmail.com"]

  spec.summary       = %q{Graphical vizualization of Ruby application dependencies.}
  spec.description   = %q{For applications that use minitest as the automated test framework. This gem provides a class for logging the dependencies of the application while the test runs, and another for analyzing those dependencies and producing a graph.}
  spec.homepage      = "https://github.com/tmzhuang/dependency_grapher"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "ruby-graphviz"
  spec.add_dependency "activesupport"
  #spec.add_dependency "ruby-xslt"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "pry"
end

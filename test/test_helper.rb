$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'dependency_grapher'
require 'minitest/unit'
require 'minitest/autorun'
require 'minitest/reporters'
require 'byebug'

Minitest::Reporters.use!

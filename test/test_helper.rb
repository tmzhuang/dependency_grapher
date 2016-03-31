$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'dependency_grapher'
require 'minitest/autorun'
require 'minitest/reporters'
require 'mocha/mini_test'
require 'byebug'
require 'pry'

Minitest::Reporters.use!

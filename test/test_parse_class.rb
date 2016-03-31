require 'test_helper'
require_relative "../lib/dependency_grapher/parse_class"

class TestParseClass < Minitest::Test
  def setup
    @class1 = Class.new
    @class2 = @class1.new
  end

  def teardown 
  end

  def test_parse
    parsed = DependencyGrapher::ParseClass.call(@class2)
  end
end

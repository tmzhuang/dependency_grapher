require 'test_helper'
require 'dependency_grapher'

class GrapherTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::DependencyGrapher::VERSION
  end
end

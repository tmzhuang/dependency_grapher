require 'test_helper'

class DependencyGrapherTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::DependencyGrapher::VERSION
  end
end

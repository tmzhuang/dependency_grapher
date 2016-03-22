require 'test_helper'

class LoggerTest < Minitest::Test
  def setup
    # Create temp class A
    self.class.const_set :A, Class.new {
      def self.call
      end
    }
  end

  def teardown 
  end

  def test_enable
    logger = DependencyGrapher::Logger.new
    logger.enable
    A.call
    logger.disable
    p logger.dependencies
    assert logger.dependencies.size >= 0
  end
end

require 'test_helper'
require 'set'

class TestFilter < Minitest::Test
  def setup
    # TODO: Find a way to share test data across tests
    @defined_class_1 = "Module1::Class1"
    @method_id_1 = "the_method_1"
    @path_1 = "path/to/method_1.rb"
    @lineno_1 = "111"
    @method_1 = DependencyGrapher::Method.new(@defined_class_1, @method_id_1, @path_1, @lineno_1)

    @defined_class_2 = "Class2"
    @method_id_2 = "the_method_2"
    @path_2 = "path/to/method_2.rb"
    @lineno_2 = "222"
    @method_2 = DependencyGrapher::Method.new(@defined_class_2, @method_id_2, @path_2, @lineno_2)

    @defined_class_3 = "Module3::Class3"
    @method_id_3 = "the_method_3"
    @path_3 = "path/to/method_3.rb"
    @lineno_3 = "333"
    @method_3 = DependencyGrapher::Method.new(@defined_class_3, @method_id_3, @path_3, @lineno_3)

    @defined_class_4 = "Class4"
    @method_id_4 = "the_method_4"
    @path_4 = "path/to/module_4.rb"
    @lineno_4 = "444"
    @method_4 = DependencyGrapher::Method.new(@defined_class_4, @method_id_4, @path_4, @lineno_4)

    @dependency_1 = DependencyGrapher::Dependency.new(@method_1, @method_2)
    @dependency_2 = DependencyGrapher::Dependency.new(@method_2, @method_3)
    @dependency_3 = DependencyGrapher::Dependency.new(@method_4, @method_2)
    @dependency_4 = DependencyGrapher::Dependency.new(@method_2, @method_2)

    @dependencies = Set.new
    @dependencies << @dependency_1 << @dependency_2 << @dependency_3 << @dependency_4

  end

  def test_initialize_with_params
    analyzer = DependencyGrapher::Analyzer.new
    assert_nil analyzer.dependencies
  end

  def test_initialize_without_params
    analyzer = DependencyGrapher::Analyzer.new(@dependencies)
    refute_nil analyzer.dependencies
  end

  def test_load_dependencies
    analyzer = DependencyGrapher::Analyzer.new
    analyzer.load_dependencies(@dependencies)
    assert_equal @dependencies, analyzer.dependencies
  end

  # TODO: fill in missing tests
  def test_set_method_types
  end

  def test_set_dependency_flags
  end
end

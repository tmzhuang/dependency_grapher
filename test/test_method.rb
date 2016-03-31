require 'test_helper'

class TestMethod < Minitest::Test
  def setup
    @defined_class_1 = "Module1::Class1"
    @method_id_1 = "the_method_1"
    @path_1 = "/the/path/to/file_1.rb"
    @lineno = "123"
    

    @defined_class_2 = "Class2"
    @method_id_2 = "the_method_2"
  end

  def teardown
  end

  def test_serialize
    method = DependencyGrapher::Method.new(@defined_class_1, @method_id_1, @path_1, @lineno)
    yaml_string = method.serialize
    loaded_method = DependencyGrapher::Method.deserialize(yaml_string)
    assert loaded_method.method_id == @method_id_1
  end
end

require 'test_helper'

class DependencyTest < Minitest::Test
  def setup
    p "in dt setup"
    @defined_class_1 = "Module1::Class1"
    @method_id_1 = "the_method_1"
    @method_1 = DependencyGrapher::Method.new(@defined_class_1, @method_id_1)

    @defined_class_2 = "Class2"
    @method_id_2 = "the_method_2"
    @method_2 = DependencyGrapher::Method.new(@defined_class_2, @method_id_2)

    @dependency = DependencyGrapher::Dependency.new(@method_1, @method_2)
    
    @file = File.open("dependency.yml", 'w')
  end

  def teardown 
    p "in dt teardown"
  end

  def test_serialize
    yaml_string = @dependency.serialize
    loaded_dependency = DependencyGrapher::Dependency.deserialize(yaml_string)
    assert loaded_dependency.receiver == @receiver_1
  end

  def test_deserialize_from_file
    yaml_string = @dependency.serialize
    @file.puts yaml_string
    yaml_string = @file.read
    assert loaded_dependency.receiver == @receiver_1
  end
end

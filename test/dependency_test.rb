require 'test_helper'

class DependencyTest < Minitest::Test
  def setup
    @defined_class_1 = "Module1::Class1"
    @method_id_1 = "the_method_1"
    @caller = DependencyGrapher::Method.new(@defined_class_1, @method_id_1)

    @defined_class_2 = "Class2"
    @method_id_2 = "the_method_2"
    @receiver = DependencyGrapher::Method.new(@defined_class_2, @method_id_2)

    @dependency = DependencyGrapher::Dependency.new(@method_1, @method_2)
    
    @file = File.open("dependency.yml", 'w')
  end

  def teardown 
  end

  def test_serialize
    yaml_string = @dependency.serialize
    loaded_dependency = DependencyGrapher::Dependency.deserialize(yaml_string)
    assert loaded_dependency.receiver == @dependency.receiver
  end

  def test_deserialize_from_file
    yaml_string = @dependency.serialize
    @file.puts yaml_string
    @file.close
    @file = File.open("dependency.yml", 'r')
    yaml_string = @file.read
    loaded_dependency = DependencyGrapher::Dependency.deserialize(yaml_string)
    assert loaded_dependency.receiver == @dependency.receiver
  end
end

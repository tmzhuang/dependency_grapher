require 'test_helper'
require_relative '../lib/dependency_grapher/method'
require_relative '../lib/dependency_grapher/dependency'

class TestDependency < Minitest::Test
  def setup
    @defined_class_1 = "Module1::Class1"
    @method_id_1 = "the_method_1"
    @path_1 = "/vagrant/app/controllers/users_controller.rb"
    @lineno_1 = "123"
    @kaller = DependencyGrapher::Method.new(@defined_class_1, @method_id_1, @path_1, @lineno_1)

    @defined_class_2 = "Class2"
    @method_id_2 = "the_method_2"
    @path_2 = "/vagrant/app/controllers/users_controller.rb"
    @lineno_2 = "123"
    @receiver = DependencyGrapher::Method.new(@defined_class_2, @method_id_2, @path_2, @lineno_2)
    @receiver.types << :framework

    @dependency = DependencyGrapher::Dependency.new(@kaller, @receiver)
    @dependency.flags << "violation"
    @expected_yaml = "--- !ruby/object:DependencyGrapher::Dependency\nkaller: !ruby/object:DependencyGrapher::Method\n  defined_class: Module1::Class1\n  method_id: the_method_1\n  path: \"/vagrant/app/controllers/users_controller.rb\"\n  lineno: '123'\n  types: !ruby/object:Set\n    hash: {}\nreceiver: !ruby/object:DependencyGrapher::Method\n  defined_class: Class2\n  method_id: the_method_2\n  path: \"/vagrant/app/controllers/users_controller.rb\"\n  lineno: '123'\n  types: !ruby/object:Set\n    hash:\n      :framework: true\nflags: !ruby/object:Set\n  hash:\n    violation: true\ncount: 1\n"
  end

  def test_serialize
    yaml_string = @dependency.serialize
    assert_equal @expected_yaml, yaml_string
  end

  def test_deserialize_kaller
    loaded_dependency = DependencyGrapher::Dependency.deserialize(@expected_yaml)
    assert_equal @dependency.kaller.id, loaded_dependency.kaller.id 
  end

  def test_deserialize_receiver
    loaded_dependency = DependencyGrapher::Dependency.deserialize(@expected_yaml)
    assert_equal @dependency.receiver.id, loaded_dependency.receiver.id 
  end

  def test_deserialize_flags
    loaded_dependency = DependencyGrapher::Dependency.deserialize(@expected_yaml)
    assert_equal @dependency.flags, loaded_dependency.flags
  end

  def test_kaller
    assert_equal @kaller, @dependency.kaller
  end

  def test_receiver
    assert_equal @receiver, @dependency.receiver
  end

  def test_count
    assert_equal 1, @dependency.count
  end

  def test_touch
    10.times do
      @dependency.touch
    end

    assert_equal 11, @dependency.count
  end
end

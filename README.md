# DependencyGrapher
DependencyGrapher is a tool for highlighting certain method calls in your Rails application. Specifically, it highlights cases where classes makes calls to external frameworks that are already being referenced to by service objects. DependencyGrapher tries to use your testing framework to infer method dependencies between classes. It assumes that all service objects are in the `app/services/' folder.

`users_controller.rb`:
```ruby
...
  def get_logger
    logger = DependencyGrapher::Logger.new
    logger.enable
    logger.disable
  end
...
```
`user.rb`:
```ruby
...
  def get_logger
    logger = GetLogger.call
  end
...
```
`user_test.rb`:
```ruby
class UserTest < ActiveSupport::TestCase
  test "dep1" do
    #p "in UserTest the truth"
    @user = users(:tianming)
    @skill = skills(:ruby)
    @user.add_skill(@skill)
    @user.get_logger
    assert @user.has_skill?(@skill)
  end

  test "dep2" do
    #p "in UserTest the truth"
    UsersController.new.get_logger
    assert true
  end
end
  def get_logger
    logger = GetLogger.call
  end
```
Sample output:
![sample output](http://imgh.us/dependencies_1.svg)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dependency_grapher'
```

## Usage
In your test helpers file `test/test_helper`, include `DependencyGrapher::TestHelpers` to your tests as shown below:
```ruby
class ActionController::TestCase
  include DependencyGrapher::TestHelpers
  #include DependencyGrapher::TestHelpers
end

class ActiveSupport::TestCase
  include DependencyGrapher::TestHelpers
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
end
```
Run `rake test` to run your tests. DependencyGrapher will log all method calls in your tests to produce `dependencies.yml`, which it will use to produce graphs.

`rake dep:graph` to produce a svg graph.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dependency_grapher. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


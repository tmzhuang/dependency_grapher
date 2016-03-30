# DependencyGrapher
DependencyGrapher is a tool for highlighting certain method calls in your Rails application. Specifically, it highlights cases where classes makes calls to external frameworks that are already being referenced to by service objects. DependencyGrapher tries to use your testing framework to infer method dependencies between classes. It assumes that all service objects are in the `app/services/' folder.

DependencyGrapher will only show classes that are direct neighbours of "known classes". Known classes are inferred from ruby files under `Rails.application.config.eager_load_paths`. Furthermore, all services are assumed be in the /app/services/folder. A "violation" is when there exists a receiver of a service class that is being called by a non-service class. There edges are shown in red in the resulting graph.

Example:
`app/controllers/users_controller.rb`:
```ruby
...
  def get_logger
    logger = DependencyGrapher::Logger.new
    logger.enable
    logger.disable
  end
...
```

`app/models/user.rb`:
```ruby
...
  def get_logger
    logger = GetLogger.call
  end
...
```

`app/services/get_logger.rb`:
```ruby
class GetLogger
  def self.call
    DepedencyGrapher::Logger.new
  end
end
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
![sample output](http://imgh.us/dependencies_4.svg)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dependency_grapher'
```

And run `bundle install`.

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
DependencyGrapher requires you first to run your unit tests to produce set of dependencies (outputted to your project folder as dependencies.yml). The parts of your system that are not touched by the tests will not be shown in the graph. 

After the tests have complete, run `rake dep:graph` to produce a svg graph.
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dependency_grapher. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


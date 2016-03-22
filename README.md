# DependencyGrapher
DependencyGrapher is a tool for highlighting certain method calls in your Rails application. Specifically, it highlights cases where classes makes calls to external frameworks that are already being referenced to by service objects. It assumes that all service objects are in the `app/services/' folder.

Sample output:
!(http://i.imgur.com/7HDpVMG.png)


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
Running `rake test` will now also profile your code for dependcies.

`rake depgra::png` to produce a png graph.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dependency_grapher. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


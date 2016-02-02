# DependencyGrapher
This gem is a library providing several classes for graphing the dependencies of your Rails application.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dependency_grapher'
```

## Usage
Intialize a logger with DependencyGrapher::Logger.new. In your test_helper.rb, turn the logger on in a @setup function by calling Logger#enable. Disable the logger between tests in @teardown with Logger#disable. Have your test call Minitest#afterrun and create a DependencyGrapher:Analyzer. The Analyzer class takes the dependencies and clusters generated by the logger. For example:
```ruby
#@logger is a DependencyGrapher::Logger instance that has already profiled your Rails app
analyzer = DependencyGrapher:Analyzer.new(@logger.dependencies, @logger.clusters)
```
Call Analyzer#graph to produce an graphical output to graph.png.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dependency_grapher. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


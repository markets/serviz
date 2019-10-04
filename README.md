# Serviz

[![Gem](https://img.shields.io/gem/v/serviz.svg?style=flat-square)](https://rubygems.org/gems/serviz)
[![Build Status](https://img.shields.io/travis/markets/serviz.svg?style=flat-square)](https://travis-ci.org/markets/serviz)
[![Maintainability](https://api.codeclimate.com/v1/badges/871bdafe6ca410b4b64a/maintainability)](https://codeclimate.com/github/markets/serviz/maintainability)

> Minimalistic Service or Command Class interface for Ruby

`Serviz` provides an interface and to unify your Sevices or Command objects.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'serviz'
```

And then execute:

    > bundle install

Or install it yourself as:

    > gem install serviz

## Usage

- Inherit from `Serviz::Base` class
- Implement `#call` method:
  - add results via `self.result=`
  - add errors via `self.errors=`
  - return `self` always

**Example:**

```ruby
class RegisterUser < Serviz::Base
  def initialize(user, app)
    @user = user
    @app = app
  end

  def call
    if @user.valid?
      @user.register!(@app)
      self.result = user
    else
      self.errors = 'Invalid user'
    end

    self
  end
end
```

```ruby
service = RegisterUser.call(user, 'app01')

if service.success?
  puts "Success! #{service.result.name} registered!"
else
  puts "Error! #{service.errors.join(', ')}"
end
```

## Development

Any kind of feedback, bug report, idea or enhancement are much appreciated.

To contribute, just fork the repo, hack on it and send a pull request. Don't forget to add specs for behaviour changes and run the test suite:

    > bundle exec rspec

## License

Copyright (c) Marc Anguera. `Serviz` is released under the [MIT](LICENSE) License.

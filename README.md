# Serviz

[![Gem](https://img.shields.io/gem/v/serviz.svg?style=flat-square)](https://rubygems.org/gems/serviz)
[![Build Status](https://img.shields.io/travis/markets/serviz.svg?style=flat-square)](https://travis-ci.org/markets/serviz)
[![Maintainability](https://api.codeclimate.com/v1/badges/871bdafe6ca410b4b64a/maintainability)](https://codeclimate.com/github/markets/serviz/maintainability)

> Minimalistic Service Class Interface for Ruby

`Serviz` provides a minimal interface to unify and homogenize your *Sevice* or *Command* objects in your Ruby code.

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

- Your class should inherit from `Serviz::Base` class
- Your class should implement `#call` method:
  - add results via `self.result=`
  - add errors via `self.errors=`
  - return `self` always

**Example:**

```ruby
class RegisterUser < Serviz::Base
  def initialize(user)
    @user = user
  end

  def call
    if @user.valid?
      @user.register
      @user.send_register_email

      self.result = @user
    else
      self.errors << 'Invalid user'
    end

    self
  end
end
```

```ruby
operation = RegisterUser.call(user)

if operation.success?
  puts "[SUCCESS] #{operation.result.name} registered!"
else
  puts "[ERROR] #{operation.errors.join(', ')}"
end
```

## Development

Any kind of feedback, bug report or enhancement are really welcome!

To contribute, just fork the repo, hack on it and send a pull request. Don't forget to add specs for behaviour changes and run the test suite:

    > bundle exec rspec

## License

Copyright (c) Marc Anguera. `Serviz` is released under the [MIT](LICENSE) License.

# Serviz

[![Gem](https://img.shields.io/gem/v/serviz.svg?style=flat-square)](https://rubygems.org/gems/serviz)
[![Build Status](https://github.com/markets/serviz/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/markets/serviz/actions)
[![Maintainability](https://api.codeclimate.com/v1/badges/871bdafe6ca410b4b64a/maintainability)](https://codeclimate.com/github/markets/serviz/maintainability)

> Minimalistic Service Class Interface for Ruby

`Serviz` provides a minimal interface to unify and homogenize your *Service* or *Command* objects in your Ruby code.

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

- Your class should inherit from `Serviz::Base`
- Your class should implement a `#call` method
- Return the _result_ via `self.result=`
- Add _errors_ via `self.errors<<`
- Check the status via the provided `#success?` or `#failure?` methods

### Example

First, you should create a _Serviz_ class:

```ruby
class RegisterUser < Serviz::Base
  def initialize(user)
    @user = user
  end

  def call
    if @user.valid?
      @user.register_and_notify

      self.result = @user
    else
      self.errors << 'Invalid user'
    end
  end
end
```

Now, you can run it by using the `call` method:

```ruby
operation = RegisterUser.call(user)

if operation.success?
  user = operation.result
  puts "Success! #{user.name} registered!"
else
  puts "Error! #{operation.error_messages}"
end
```

As you can see in the example above, you can use the `success?` method to check if your operation succeed. You can also use the `ok?` alias.

In case you want to check if the run failed, you can use the `failure?` method (or the alias `error?`):

```ruby
if operation.failure?
  puts "Error! Please try again ..."
  return
end
```

### Block syntax

You may like to use the _block_ syntax:

```ruby
RegisterUser.call(user) do |operation|
  puts "Success!" if operation.ok?
end
```

## Development

Any kind of feedback, bug report or enhancement are really welcome!

To contribute, just fork the repo, hack on it and send a pull request. Don't forget to add specs for behaviour changes and run the test suite:

    > bundle exec rspec

## License

Copyright (c) Marc Anguera. `Serviz` is released under the [MIT](LICENSE) License.

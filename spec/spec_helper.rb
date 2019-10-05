require "bundler/setup"
require "serviz"

require_relative "scenarios"

RSpec.configure do |config|
  config.order = :rand
  config.disable_monkey_patching!
end

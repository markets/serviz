require "bundler/setup"
require "serviz"

RSpec.configure do |config|
  config.order = :rand
  config.disable_monkey_patching!
end

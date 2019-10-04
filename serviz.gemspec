require "./lib/serviz/version"

Gem::Specification.new do |spec|
  spec.name          = "serviz"
  spec.version       = Serviz::VERSION
  spec.summary       = "Minimalistic Service Class for Ruby"
  spec.description   = spec.summary
  spec.authors       = ["markets"]
  spec.email         = ["srmarc.ai@gmail.com"]
  spec.homepage      = "https://github.com/markets/serviz"
  spec.license       = "MIT"
  spec.files         = Dir.glob("lib/**/*")
  spec.test_files    = Dir.glob("spec/**/*")
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end

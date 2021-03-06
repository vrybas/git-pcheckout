# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'git-pcheckout/version'

Gem::Specification.new do |spec|
  spec.name          = "git-pcheckout"
  spec.version       = GitPcheckout::VERSION
  spec.authors       = ["Vladimir Rybas"]
  spec.email         = ["vladimirrybas@gmail.com"]
  spec.summary       = %q{Git command to evenly checkout local/remote branches and source/fork pull requests by URL (with Hub)}
  spec.description   = %q{Git command to evenly checkout local/remote branches and source/fork pull requests by URL (with Hub)}
  spec.homepage      = "https://github.com/vrybas/git-pcheckout"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "codeclimate-test-reporter"
end

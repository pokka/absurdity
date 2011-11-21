# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "absurdity/version"

Gem::Specification.new do |s|
  s.name        = "absurdity"
  s.version     = Absurdity::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Tim Payton", "Ömür Özkir"]
  s.email       = "opensource@xing.com"
  s.homepage    = "http://www.github.com/xing/absurdity/"
  s.summary     = %q{Absurdly simple a/b testing}
  s.description = %q{See summary}

  s.rubyforge_project = "absurdity"

  s.add_dependency("redis", ">= 0")
  s.add_dependency("rake", ">= 0.8.7")

  s.add_development_dependency("mock_redis", ">= 0")
  s.add_development_dependency("mocha", ">= 0")
  s.add_development_dependency("minitest", ">= 0")
  s.add_development_dependency("turn", ">= 0")

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

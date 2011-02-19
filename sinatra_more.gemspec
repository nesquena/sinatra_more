# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sinatra_more/version"

Gem::Specification.new do |s|
  s.name = %q{sinatra_more}
  s.version = SinatraMore::VERSION
  s.platform    = Gem::Platform::RUBY

  s.authors = ["Nathan Esquenazi"]
  s.email = %q{nesquena@gmail.com}
  s.date = %q{2011-02-18}
  s.default_executable = %q{sinatra_gen}
  s.description = %q{Expands sinatra with standard helpers and tools to allow for complex applications}
  s.summary = s.description

  s.add_dependency     "sinatra",       ">= 0.9.2"
  s.add_dependency     "tilt",          ">= 0.2"
  s.add_dependency     "thor",          ">= 0.11.8"
  s.add_dependency     "activesupport"
  s.add_dependency     "bundler",       ">= 0.9.2"
  s.add_development_dependency "haml",      ">= 2.2.14"
  s.add_development_dependency "shoulda",   ">= 2.10.2"
  s.add_development_dependency "mocha",     ">= 0.9.7"
  s.add_development_dependency "rack-test", ">= 0.5.0"
  s.add_development_dependency "webrat",     ">= 0.5.1"
  s.add_development_dependency "jeweler"
  s.add_development_dependency "builder"
  s.add_development_dependency "tmail"
  s.add_development_dependency "xml-simple"
  s.add_development_dependency "warden"

  s.rubyforge_project = "sinatra_more"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end


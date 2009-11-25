# $ rake version:bump:patch release

require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "sinatra_more"
    gem.summary = "Expands sinatra to allow for complex applications"
    gem.description = "Expands sinatra with standard helpers and tools to allow for complex applications"
    gem.email = "nesquena@gmail.com"
    gem.homepage = "http://github.com/nesquena/sinatra_more"
    gem.authors = ["Nathan Esquenazi"]
    gem.add_runtime_dependency     "sinatra",       ">= 0.9.2"
    gem.add_runtime_dependency     "tilt",          ">= 0.2"
    gem.add_runtime_dependency     "thor",          ">= 0.11.8"
    gem.add_runtime_dependency     "activesupport", ">= 2.2.2"
    gem.add_runtime_dependency     "bundler"
    gem.add_development_dependency "haml",          ">= 2.2.14"
    gem.add_development_dependency "shoulda",       ">= 2.10.2"
    gem.add_development_dependency "mocha",         ">= 0.9.7"
    gem.add_development_dependency "rack-test",     ">= 0.5.0"
    gem.add_development_dependency "webrat",        ">= 0.5.1"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "sinatra_more #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

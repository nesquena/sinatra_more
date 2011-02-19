require 'thor/group'
require File.dirname(__FILE__) + "/../lib/sinatra_more/support_lite"
require File.dirname(__FILE__) + '/generator_actions'
require File.dirname(__FILE__) + '/components/component_actions'
Dir[File.dirname(__FILE__) + "/{base_app,components}/**/*.rb"].each { |lib| require lib }

module SinatraMore
  class SkeletonGenerator < Thor::Group
    # Define the source template root
    def self.source_root; File.dirname(__FILE__); end
    def self.banner; "sinatra_gen [app_name] [path] [options]"; end

    # Include related modules
    include Thor::Actions
    include SinatraMore::GeneratorActions
    include SinatraMore::ComponentActions

    desc "Description:\n\n\tsinatra_gen is the sinatra_more generators which generate or build on Sinatra applications."

    argument :name, :desc => "The name of your sinatra app"
    argument :path, :desc => "The path to create your app"
    class_option :run_bundler, :aliases => '-b', :default => false, :type => :boolean

    # Definitions for the available customizable components
    component_option :orm,      "database engine",    :aliases => '-d', :choices => [:datamapper, :mongomapper, :activerecord, :sequel, :couchrest]
    component_option :test,     "testing framework",  :aliases => '-t', :choices => [:bacon, :shoulda, :rspec, :testspec, :riot]
    component_option :mock,     "mocking library",    :aliases => '-m', :choices => [:mocha, :rr]
    component_option :script,   "javascript library", :aliases => '-s', :choices => [:jquery, :prototype, :rightjs]
    component_option :renderer, "template engine",    :aliases => '-r', :choices => [:erb, :haml]

    # Copies over the base sinatra starting application
    def setup_skeleton
      self.destination_root = File.join(path, name)
      @class_name = name.classify
      directory("base_app/", self.destination_root)
      store_component_config('.components')
    end

    # For each component, retrieve a valid choice and then execute the associated generator
    def setup_components
      self.class.component_types.each do |comp|
        choice = resolve_valid_choice(comp)
        execute_component_setup(comp, choice)
      end
    end

    # Bundle all required components using bundler and Gemfile
    def bundle_dependencies
      if options[:run_bundle]
        say "Bundling application dependencies using bundler..."
        in_root { run 'bundle install' }
      end
    end
  end
end

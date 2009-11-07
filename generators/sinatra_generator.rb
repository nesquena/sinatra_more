require File.dirname(__FILE__) + '/generator_components'
Dir[File.dirname(__FILE__) + "/{base_app,components}/**/*.rb"].each { |lib| require lib }

module SinatraMore
  class Generator < Thor::Group
    # Define the source template root
    def self.source_root; File.dirname(__FILE__); end

    # Include related modules
    include Thor::Actions
    include SinatraMore::GeneratorComponents
    
    argument :name, :desc => "The name of your sinatra app"
    argument :path, :desc => "The path to create your app"

    # Definitions for the available customizable components
    component_option :orm,      "Database engine",    :aliases => '-d', :choices => [:sequel, :datamapper, :mongomapper, :activerecord]
    component_option :test,     "Testing framework",  :aliases => '-t', :choices => [:bacon, :shoulda, :rspec]
    component_option :mock,     "Mocking library",    :aliases => '-m', :choices => [:rr, :mocha]
    component_option :script,   "Javascript library", :aliases => '-s', :choices => [:jquery, :prototype, :rightjs]
    component_option :renderer, "Template Engine",    :aliases => '-r', :choices => [:haml, :erb]

    # Copies over the base sinatra starting application
    def setup_skeleton
      @class_name = name.classify
      directory("base_app/", root_path)
    end

    # For each component, retrieve a valid choice and then execute the associated generator
    def setup_components
      self.class.component_types.each do |comp|
        choice = resolve_valid_choice(comp)
        execute_component_setup(comp, choice)
      end
    end
    
  end
end
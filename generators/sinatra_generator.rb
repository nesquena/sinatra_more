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
    component_option :mock,     "Mocking library",    :aliases => '-m', :choices => [:rr, :mocha]
    component_option :test,     "Testing framework",  :aliases => '-t', :choices => [:bacon, :shoulda, :rspec]
    component_option :script,   "Javascript library", :aliases => '-s', :choices => [:jquery, :prototype, :rightjs]
    component_option :renderer, "Template Engine",    :aliases => '-r', :choices => [:haml, :erb]
    component_option :orm,      "Database engine",    :aliases => '-d', :choices => [:sequel, :datamapper, :mongomapper, :activerecord]

    # Copies over the base sinatra starting application
    def setup_skeleton
      @class_name = name.classify
      directory("base_app/", root_path)
    end

    # For each component, apply the component setup if valid choice; otherwise display alternate choices
    def setup_components
      self.class.component_types.each do |comp|
        valid_choice?(comp) ? execute_component_setup(comp) : display_available_choices(comp)
      end
    end
    
  end
end
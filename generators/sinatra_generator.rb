require File.dirname(__FILE__) + '/configured_components'
Dir[File.dirname(__FILE__) + "/{base_app,components}/**/*.rb"].each { |lib| require lib }

module SinatraMore
  class Generator < Thor::Group
    # Define the source template root
    def self.source_root; File.dirname(__FILE__); end

    # Include related modules
    include Thor::Actions
    include SinatraMore::ConfiguredComponents
    include SinatraMore::GeneratorHelpers

    argument :name, :desc => "The name of your sinatra app"
    argument :path, :desc => "The path to create your app"

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

    component_types.each do |comp|
      define_method("perform_setup_for_#{comp}") do
        chosen_option = options[comp]
        if valid_choice?(chosen_option, comp)
          say "Applying '#{chosen_option}' (#{comp})...", :yellow
          self.class.send(:include, generator_module_for(chosen_option, comp))
          send("setup_#{comp}") if respond_to?("setup_#{comp}")
        else # chosen not a supported option
          available_string = available_choices_for(comp).join(", ")
          say("Option for --#{comp} '#{chosen_option}' is not available. Available: #{available_string}", :red)
        end
      end
    end

  end
end

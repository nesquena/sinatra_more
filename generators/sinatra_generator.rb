require File.dirname(__FILE__) + '/configured_components'
Dir[File.dirname(__FILE__) + "/{base_app,components}/**/*.rb"].each { |lib| require lib }

module SinatraMore
  class Generator < Thor::Group 
    include Thor::Actions
    include SinatraMore::ConfiguredComponents
    include SinatraMore::GeneratorHelpers
       
    argument :name, :desc => "The name of your sinatra app"
    argument :path, :desc => "The path to create your app"

    component_option :mock,     "Mocking library",      :aliases => '-m'
    component_option :test,     "Testing framework",    :aliases => '-t'
    component_option :script,   "Javascript library",   :aliases => '-s'
    component_option :renderer, "Template Engine",      :aliases => '-r'
    component_option :orm,      "Database engine",      :aliases => '-d'

    component_types.each do |comp|
      define_method("include_#{comp}") do
        option = options[comp.to_sym]
        raise "Option not supported" unless valid_option?(option, comp)
        self.class.send(:include, generator_module_for(option, comp))
      end
    end

    def self.source_root
      File.dirname(__FILE__)
    end

    def setup_skeleton
      @class_name = name.classify
      directory("base_app/", root_path)
    end
    
    component_types.each do |comp|
      define_method("perform_setup_for_#{comp}") do
        say "Applying '#{options[comp.to_sym]}' (#{comp})...", :yellow
        send("setup_#{comp}") if respond_to?("setup_#{comp}")
      end
    end

  end
end

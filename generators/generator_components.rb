module SinatraMore
  module GeneratorComponents
    
    def self.included(base)
      base.extend(ClassMethods)
    end

    # Returns true if the option passed is a valid choice for component
    # valid_option?(:mock,'rr')
    def valid_choice?(component,choice)
      return true if choice == 'none'
      self.class.available_choices_for(component).include? choice.to_sym
    end

    # Performs the necessary generator for a given component choice
    # execute_component_setup(:mock, 'rr')
    def execute_component_setup(component, choice)
      return true if choice == 'none'
      say "Applying '#{choice}' (#{component})...", :yellow
      self.class.send(:include, generator_module_for(choice, component))
      send("setup_#{component}") if respond_to?("setup_#{component}")
    end

    # Displays to the console the available options for the given component choice
    # display_available_choices(:mock, 'rr')
    def display_available_choices(component,choice)
      available_string = self.class.available_choices_for(component).join(", ")
      say("Option for --#{component} '#{choice}' is not available. Available: #{available_string} or none", :red)
      ask("Please enter a valid option:")
    end

    # Returns the related module for a given component and option
    # generator_module_for('rr', :mock)
    def generator_module_for(choice, component)
      "SinatraMore::#{choice.to_s.capitalize}#{component.to_s.capitalize}Gen".constantize
    end

    # Returns the root_path for the generated application or the calculated relative specified path
    # root_path('public/javascripts/example.js')
    def root_path(*paths)
      paths.blank? ? File.join(path, name) : File.join(path, name, *paths)
    end

    module ClassMethods
      # Defines a class option to allow a component to be chosen and add to component type list
      # Also builds the available_choices hash of which component choices are supported
      # component_option :test, "Testing framework", :aliases => '-t', :choices => [:bacon, :shoulda]
      def component_option(name, description, options = {})
        (@available_choices ||= Hash.new({}))[name] = options[:choices]
        (@component_types ||= []) << name
        class_option name, :default => default_for(name), :aliases => options[:aliases]
      end

      # Returns the compiled list of component types which can be specified
      def component_types
        @component_types
      end

      # Returns the list of available choices for the given component
      def available_choices_for(component)
        @available_choices[component]
      end

      # Returns the default choice for a given component
      def default_for(component)
        available_choices_for(component).first
      end
    end
  end
end

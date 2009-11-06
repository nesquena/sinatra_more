module SinatraMore
  module ConfiguredComponents
    def self.included(base)
      base.extend(ClassMethods)
    end

    def available_choices_for(component)
      self.class.available_choices_for(component)
    end

    def default_for(component)
      self.class.default_for(component)
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

      # Returns the list of available
      def available_choices_for(component)
        @available_choices[component]
      end

      # Returns true if the option passed is a valid choice for component
      # valid_option?('rr', :mock)
      def valid_choice?(option, component)
        available_choices_for(component).include? option.to_sym
      end

      def default_for(component)
        available_choices_for(component).first
      end
    end
  end

  module GeneratorHelpers
    # root_path('public/javascripts/example.js')
    def root_path(*paths)
      paths.blank? ? File.join(path, name) : File.join(path, name, *paths)
    end

    # Returns the related module for a given component and option
    # generator_module_for('rr', :mock)
    def generator_module_for(option, component)
      "SinatraMore::#{option.to_s.capitalize}#{component.to_s.capitalize}Gen".constantize
    end
  end
end
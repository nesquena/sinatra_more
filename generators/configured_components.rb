module SinatraMore
  module ConfiguredComponents
    def self.included(base)
      # base.include(ClassMethods)
      base.extend(ClassMethods)
    end

    AVAILABLE = {
      :mocks =>     [:rr, :mocha],
      :tests =>     [:bacon, :shoulda, :rspec],
      :scripts =>   [:jquery, :prototype, :rightjs],
      :renderers => [:haml, :erb],
      :orms =>      [:sequel, :datamapper, :mongomapper, :activerecord]
    }

    def available_options_for(component)
      AVAILABLE[component.to_s.pluralize.to_sym]
    end

    module ClassMethods
      def component_types
        @component_types
      end

      # Defines a class option to allow a component to be chosen and add to component type list
      # component_option :test, "Testing framework", :aliases => '-t'
      def component_option(name, description, options = {})
        class_option name, :default => default_for(name), :aliases => options[:aliases]
        (@component_types ||= []) << name
      end

      def default_for(component)
        AVAILABLE[component.to_s.pluralize.to_sym].first
      end
    end
  end

  module GeneratorHelpers
    # root_path('public/javascripts/example.js')
    def root_path(*paths)
      paths.blank? ? File.join(path, name) : File.join(path, name, *paths)
    end

    # Returns true if the option passed is a valid choice for component
    # valid_option?('rr', :mock)
    def valid_option?(option, component)
      available_options_for(component).include? option.to_sym
    end

    # Returns the related module for a given component and option
    # generator_module_for('rr', :mock)
    def generator_module_for(option, component)
      "SinatraMore::#{option.to_s.capitalize}#{component.to_s.capitalize}Gen".constantize
    end
  end
end
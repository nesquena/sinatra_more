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
        (@component_types ||= []) << name.to_s
      end

      def default_for(component)
        AVAILABLE[component.to_s.pluralize.to_sym].first
      end
    end
  end
end

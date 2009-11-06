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
      DEFAULTS = {
        :mocks =>     :rr,
        :tests =>     :bacon,
        :scripts =>   :jquery,
        :renderers => :haml,
        :orms =>      :sequel
      }

      def component_types
        %w[test mock script renderer orm]
      end

      # component_option :test, "Testing framework", :aliases => '-t'
      def component_option(name, description, options = {})
        class_option name, :default => default_for(name), :aliases => options[:aliases]
      end

      def default_for(component)
        DEFAULTS[component.to_s.pluralize.to_sym]
      end
    end
  end
end

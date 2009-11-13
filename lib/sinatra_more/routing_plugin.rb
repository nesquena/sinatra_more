require File.dirname(__FILE__) + '/support_lite'
Dir[File.dirname(__FILE__) + '/routing_plugin/**/*.rb'].each {|file| load file }

module SinatraMore
  module RoutingPlugin
    def self.registered(app)
      # Named paths stores the named route aliases mapping to the url
      # i.e { [:account] => '/account/path', [:admin, :show] => '/admin/show/:id' }
      app.set :named_paths, {}
      app.helpers SinatraMore::RoutingHelpers

      # map constructs a mapping between a named route and a specified alias
      # the mapping url can contain url query parameters
      # map(:accounts).to('/accounts/url')
      # map(:admin, :show).to('/admin/show/:id')
      # map(:admin) { |namespace| namespace.map(:show).to('/admin/show/:id') }
      def map(*args, &block)
        named_router = SinatraMore::NamedRoute.new(self, *args)
        block_given? ? block.call(named_router) : named_router
      end

      # Used to define namespaced route configurations in order to group similar routes
      # Class evals the routes but with the namespace assigned which will append to each route
      # namespace(:admin) { get(:show) { "..." } }
      def namespace(name, &block)
        original, @_namespace = @_namespace, name
        self.class_eval(&block)
        @_namespace = original
      end

      # Hijacking route method in sinatra to replace a route alias (i.e :account) with the full url string mapping
      # Supports namespaces by accessing the instance variable and appending this to the route alias name
      # If the path is not a symbol, nothing is changed and the original route method is invoked
      def route(verb, path, options={}, &block)
        route_name = [@_namespace, path].flatten.compact
        path = named_paths[route_name] if path.kind_of? Symbol
        super verb, path, options, &block
      end
    end
  end
end

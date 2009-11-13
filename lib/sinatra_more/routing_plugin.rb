require File.dirname(__FILE__) + '/support_lite'
Dir[File.dirname(__FILE__) + '/routing_plugin/**/*.rb'].each {|file| load file }

module SinatraMore
  class NamedRoute
    def initialize(app, *names)
      @app = app
      @names = names
    end

    def to(path)
      @app.named_paths[@names] = path
    end
  end

  module RoutingHelpers
    def url_for(*names)
      values = names.extract_options!
      mapped_url = self.class.named_paths[names]
      result_url = String.new(mapped_url)
      result_url.scan(%r{/?(:\S+?)(?:/|$)}).each do |placeholder|
        value_key = placeholder[0][1..-1].to_sym
        result_url.gsub!(Regexp.new(placeholder[0]), values[value_key].to_s)
      end
      result_url
    end
  end

  module RoutingPlugin
    def self.registered(app)
      app.set :named_paths, {}
      app.helpers SinatraMore::RoutingHelpers

      def map(*args)
        NamedRoute.new(self, *args)
      end

      def namespace(name, &block)
        original, @_namespace = @_namespace, name
        self.class_eval(&block)
        @_namespace = original
      end

      def route(verb, path, options={}, &block)
        # raise "namespace: #{@_namespace}, path: #{path}, and named: #{named_paths.inspect}"
        if path.kind_of? Symbol
          route_name = [@_namespace, path].flatten.compact
          path = named_paths[route_name]
        end
        # raise path.inspect
        super verb, path, options, &block
      end
    end
  end
end

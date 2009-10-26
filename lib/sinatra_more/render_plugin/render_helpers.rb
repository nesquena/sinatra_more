module SinatraMore
  module RenderHelpers
    # Renders a erb template based on the relative path
    # erb_template 'users/new'
    def erb_template(template_path, options={})
      render_template template_path, options.merge(:template_engine => :erb)
    end

    # Renders a haml template based on the relative path
    # haml_template 'users/new'
    def haml_template(template_path, options={})
      render_template template_path, options.merge(:template_engine => :haml)
    end

    # Renders a template from a file path automatically determining rendering engine
    # render_template 'users/new'
    # options = { :template_engine => 'haml' }
    def render_template(template_path, options={})
      template_engine = options.delete(:template_engine) || resolve_template_engine(template_path)
      render template_engine.to_sym, template_path.to_sym, options
    end

    # Partials implementation which includes collections support
    # partial 'photo/_item', :object => @photo
    # partial 'photo/_item', :collection => @photos
    def partial(template, *args)
      options = args.extract_options!
      options.merge!(:layout => false)
      path = template.to_s.split(File::SEPARATOR)
      object = path[-1].to_sym
      path[-1] = "_#{path[-1]}"
      template_path = File.join(path)
      if collection = options.delete(:collection)
        collection.inject([]) do |buffer, member|
          collection_options = options.merge(:layout => false, :locals => {object => member})
          buffer << render_template(template_path, collection_options)
        end.join("\n")
      else
        render_template(template_path, options)
      end
    end
    alias render_partial partial

    private

      # Returns the template engine (i.e haml) to use for a given template_path
      # resolve_template_engine('users/new') => :haml
      def resolve_template_engine(template_path)
        resolved_template_path = File.join(self.options.views, template_path + ".*")
        template_file = Dir[resolved_template_path].first
        raise "Template path '#{template_path}' could not be located in views!" unless template_file
        template_engine = File.extname(template_file)[1..-1].to_sym
      end
  end
end

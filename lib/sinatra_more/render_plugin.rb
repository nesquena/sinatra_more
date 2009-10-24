Dir.glob(File.dirname(__FILE__) + '/render_plugin/**/*.rb').each  { |f| require f }

module SinatraMore
  module RenderPlugin
    def self.registered(app)
      app.helpers RenderHelpers
    end
  end  
end
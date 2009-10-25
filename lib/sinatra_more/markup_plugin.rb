Dir.glob(File.dirname(__FILE__) + '/markup_plugin/**/*.rb').each  { |f| require f }

module SinatraMore
  module MarkupPlugin
    def self.registered(app)
      app.helpers OutputHelpers
      app.helpers TagHelpers
      app.helpers AssetTagHelpers
      app.helpers FormHelpers
      app.helpers FormatHelpers
    end
  end  
end
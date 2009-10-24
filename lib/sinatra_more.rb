require 'sinatra/base'

require File.join(File.dirname(__FILE__) + '/sinatra_more/warden_helpers')
require File.join(File.dirname(__FILE__) + '/sinatra_more/view_helpers')
Dir.glob(File.dirname(__FILE__) + '/sinatra_more/form_builder/*.rb').each  { |f| require f }

module SinatraMore
  def self.registered(app)
    app.helpers TagHelpers
    app.helpers AssetTagHelpers
    app.helpers FormHelpers
    app.helpers FormatHelpers
    app.helpers RenderHelpers
  end
end
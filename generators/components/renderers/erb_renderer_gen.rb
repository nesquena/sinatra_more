module SinatraMore
  module ErbRendererGen    
    def setup_renderer
      inject_into_file(root_path("/config/dependencies.rb"), :after => /require gem.*?\n/) do
        "  require 'erb'"
      end
    end
  end
end
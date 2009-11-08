module SinatraMore
  module ErbRendererGen    
    def setup_renderer
      insert_require 'erb', :path => root_path("/config/dependencies.rb"), :space => 2
    end
  end
end
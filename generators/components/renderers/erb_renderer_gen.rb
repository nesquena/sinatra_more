module SinatraMore
  module ErbRendererGen    
    def setup_renderer
      insert_require 'erb', :path => "config/dependencies.rb", :indent => 2
    end
  end
end
module SinatraMore
  module HamlRendererGen
    
    HASSLE = <<-HASSLE
module HassleInitializer
  def self.registered(app)
    app.use Hassle
  end
end
HASSLE
    
    def setup_renderer
      inject_into_file(root_path("/config/dependencies.rb"), :after => /require gem.*?\n/) do
        "  %w[haml sass hassle].each { |gem| require gem }"
      end
      create_file(root_path("/config/initializers/hassle.rb"), HASSLE)
    end
  end
end
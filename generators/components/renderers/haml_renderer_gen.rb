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
      require_dependencies 'haml', 'hassle'
      create_file("config/initializers/hassle.rb", HASSLE)
      empty_directory('public/stylesheets/sass')
    end
  end
end
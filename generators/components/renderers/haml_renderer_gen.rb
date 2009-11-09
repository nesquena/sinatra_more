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
      insert_require('haml', 'sass', 'hassle', :path => 'config/dependencies.rb', :indent => 2)
      create_file("config/initializers/hassle.rb", HASSLE)
    end
  end
end
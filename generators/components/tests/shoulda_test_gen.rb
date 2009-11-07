module SinatraMore
  module ShouldaTestGen
    TEST = <<-SHOULDA
\nclass Test::Unit::TestCase
  include Rack::Test::Methods
  
  def app
    CLASS_NAME
  end
end
SHOULDA
    def setup_test
      test_config_path = root_path("/test/test_config.rb")
      inject_into_file(test_config_path, "require 'test/unit'\nrequire 'shoulda'\n", :after => "require 'rack/test'\n")
      inject_into_file(test_config_path, TEST.gsub(/CLASS_NAME/, @class_name), :after => "set :environment, :test\n")
    end
    
  end
end
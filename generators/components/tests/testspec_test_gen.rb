module SinatraMore
  module TestspecTestGen
    TEST = <<-TESTSPEC
\nclass Test::Unit::TestCase
  include Rack::Test::Methods
  
  def app
    CLASS_NAME
  end
end
TESTSPEC
    def setup_test
      test_config_path = root_path("/test/test_config.rb")
      inject_into_file(test_config_path, "require 'test/spec'\n", :after => "require 'rack/test'\n")
      inject_into_file(test_config_path, TEST.gsub(/CLASS_NAME/, @class_name), :after => "set :environment, :test\n")
    end
    
  end
end
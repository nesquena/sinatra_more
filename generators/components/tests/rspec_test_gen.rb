module SinatraMore
  module RspecTestGen
    TEST = <<-RSPEC
\nSpec::Runner.configure do |conf|
  conf.include Rack::Test::Methods
end

def app
  CLASS_NAME
end
RSPEC
    def setup_test
      test_config_path = root_path("/test/test_config.rb")
      inject_into_file(test_config_path, "require 'spec'\n", :after => "require 'rack/test'\n")
      inject_into_file(test_config_path, TEST.gsub(/CLASS_NAME/, @class_name), :after => "set :environment, :test\n")
    end
    
  end
end
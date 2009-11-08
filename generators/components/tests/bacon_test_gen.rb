module SinatraMore
  module BaconTestGen
    TEST = <<-BACON
\nclass Bacon::Context
  include Rack::Test::Methods
end

def app
  CLASS_NAME
end
BACON
    def setup_test
      test_config_path = root_path("/test/test_config.rb")
      insert_require 'bacon', :path => test_config_path
      inject_into_file(test_config_path, TEST.gsub(/CLASS_NAME/, @class_name), :after => "set :environment, :test\n")
    end
    
  end
end



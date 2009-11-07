module SinatraMore
  module MochaMockGen
    
    def setup_mock
      test_config_path = root_path("/test/test_config.rb")
      inject_into_file(test_config_path, "require 'mocha'\n", :after => "require 'rack/test'\n")
      inject_into_file(test_config_path, "  include Mocha::API\n", :after => /class.*?\n/)
    end
  end
end
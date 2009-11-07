module SinatraMore
  module MochaMockGen
    
    def setup_mock
      inject_into_file(root_path("/test/test_config.rb"), "require 'mocha'\n", 
        :after => "require File.dirname(File.dirname(__FILE__)) + \"/app\"\n")
      inject_into_file(root_path("/test/test_config.rb"), "  include Mocha::API\n", 
        :after => /class(.*)\n/)
    end
  end
end
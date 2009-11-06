module SinatraMore
  module BaconTestGen
    TEST = <<-BACON
    
class Bacon::Context
  include Rack::Test::Methods
end
BACON
    def setup_test
      inject_into_file(root_path("/test/test_config.rb"), "require 'bacon'\n", 
        :after => "require File.dirname(File.dirname(__FILE__)) + \"/app\"\n")
      inject_into_file(root_path("/test/test_config.rb"), TEST,
        :after => "set :environment, :test\n")
    end
    
  end
end



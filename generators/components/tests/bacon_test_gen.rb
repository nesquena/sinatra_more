module SinatraMore
  module BaconTestGen
    BACON_SETUP = <<-TEST
\nclass Bacon::Context
  include Rack::Test::Methods
end

def app
  CLASS_NAME
end
TEST

    def setup_test
      insert_require 'bacon', :path => "test/test_config.rb"
      insert_test_suite_setup BACON_SETUP
    end
    
  end
end



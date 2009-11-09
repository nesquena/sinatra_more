module SinatraMore
  module RiotTestGen
    RIOT_SETUP = <<-TEST
\nclass Riot::Situation
  include Rack::Test::Methods
  
  def app
    CLASS_NAME
  end
end
TEST

    def setup_test
      insert_require 'riot', :path => "test/test_config.rb"
      insert_test_suite_setup RIOT_SETUP
    end
    
  end
end
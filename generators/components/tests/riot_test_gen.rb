module SinatraMore
  module RiotTestGen
    RIOT_SETUP = <<-TEST
\nclass Riot::Situation
  include Rack::Test::Methods
  
  def app
    CLASS_NAME.tap { |app| app.set :environment, :test }
  end
end
TEST

    def setup_test
      require_dependencies 'riot', :env => :testing
      insert_test_suite_setup RIOT_SETUP
    end
    
  end
end
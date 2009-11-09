module SinatraMore
  module RiotTestGen
    TEST = <<-RIOT
\nclass Riot::Context
  include Rack::Test::Methods
  
  def app
    CLASS_NAME
  end
end
RIOT

    def setup_test
      insert_require 'riot', :path => "test/test_config.rb"
      inject_into_file("test/test_config.rb", TEST.gsub(/CLASS_NAME/, @class_name), :after => "set :environment, :test\n")
    end
    
  end
end
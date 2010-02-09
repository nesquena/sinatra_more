module SinatraMore
  module BaconTestGen
    BACON_SETUP = <<-TEST
\nclass Bacon::Context
  include Rack::Test::Methods
end

def app
  CLASS_NAME.tap { |app| app.set :environment, :test }
end
TEST

    def setup_test
      require_dependencies 'bacon', :group => :testing
      insert_test_suite_setup BACON_SETUP
    end
    
  end
end



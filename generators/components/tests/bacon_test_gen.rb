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
      insert_require 'bacon', :path => "test/test_config.rb"
      inject_into_file("test/test_config.rb", TEST.gsub(/CLASS_NAME/, @class_name), :after => "set :environment, :test\n")
    end
    
  end
end



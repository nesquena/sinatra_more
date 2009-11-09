module SinatraMore
  module TestspecTestGen
    TEST = <<-TESTSPEC
\nclass Test::Unit::TestCase
  include Rack::Test::Methods
  
  def app
    CLASS_NAME
  end
end
TESTSPEC
    def setup_test
      insert_require 'test/spec', :path => "test/test_config.rb"
      inject_into_file("test/test_config.rb", TEST.gsub(/CLASS_NAME/, @class_name), :after => "set :environment, :test\n")
    end
    
  end
end
module SinatraMore
  module ShouldaTestGen
    TEST = <<-SHOULDA
\nclass Test::Unit::TestCase
  include Rack::Test::Methods
  
  def app
    CLASS_NAME
  end
end
SHOULDA
    def setup_test
      insert_require 'test/unit', :path => "test/test_config.rb"
      insert_require 'shoulda', :path => "test/test_config.rb"
      inject_into_file("test/test_config.rb", TEST.gsub(/CLASS_NAME/, @class_name), :after => "set :environment, :test\n")
    end
    
  end
end
module SinatraMore
  module RspecTestGen
    TEST = <<-RSPEC
\nSpec::Runner.configure do |conf|
  conf.include Rack::Test::Methods
end

def app
  CLASS_NAME
end
RSPEC
    def setup_test
      insert_require 'spec', :path => "test/test_config.rb"
      inject_into_file("test/test_config.rb", TEST.gsub(/CLASS_NAME/, @class_name), :after => "set :environment, :test\n")
    end
    
  end
end
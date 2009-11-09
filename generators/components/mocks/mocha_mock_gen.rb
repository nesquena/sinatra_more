module SinatraMore
  module MochaMockGen
    def setup_mock
      insert_require 'mocha', :path => "test/test_config.rb", :indent => 2, :after => "require 'rack/test'\n"
      inject_into_file("test/test_config.rb", "  include Mocha::API\n", :after => /class.*?\n/)
    end
  end
end

module SinatraMore
  module MochaMockGen
    def setup_mock
      insert_require 'mocha', :path => "test/test_config.rb", :after => "require 'rack/test'\n"
      insert_mocking_include "Mocha::API"
    end
  end
end
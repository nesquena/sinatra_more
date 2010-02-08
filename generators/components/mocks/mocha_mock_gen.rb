module SinatraMore
  module MochaMockGen
    def setup_mock
      require_dependencies 'mocha', :group => :testing
      insert_mocking_include "Mocha::API", :path => "test/test_config.rb"
    end
  end
end
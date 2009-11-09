module SinatraMore
  module RrMockGen
    def setup_mock
      insert_require 'rr', :path => "test/test_config.rb", :after => "require 'rack/test'\n"
      insert_mocking_include "RR::Adapters::RRMethods"
    end
  end
end
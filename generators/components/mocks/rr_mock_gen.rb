module SinatraMore
  module RrMockGen
    def setup_mock
      insert_require 'rr', :path => "test/test_config.rb", :indent => 2, :after => "require 'rack/test'\n"
      inject_into_file("test/test_config.rb", "  include RR::Adapters::RRMethods\n", :after => /class.*?\n/)
    end
  end
end

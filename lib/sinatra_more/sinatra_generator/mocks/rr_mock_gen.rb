module SinatraMore
  module RrMockGen
    
    def build_mock
      inject_into_file(@root_path + "/test/test_config.rb", "require 'rr'\n", 
        :after => "require File.dirname(File.dirname(__FILE__)) + \"/app\"\n")
      inject_into_file(@root_path + "/test/test_config.rb", "  include RR::Adapters::RRMethods\n", 
        :after => /class(.*)\n/)
    end
  end
end
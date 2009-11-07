module SinatraMore
  module RrMockGen
    
    def setup_mock
      inject_into_file(root_path("/test/test_config.rb"), "require 'rr'\n", 
        :after => "require File.dirname(File.dirname(__FILE__)) + \"/app\"\n")
      gsub_file root_path("/test/test_config.rb"), /class.*/, "\\1  include RR::Adapters::RRMethods\n"
    end
  end
end
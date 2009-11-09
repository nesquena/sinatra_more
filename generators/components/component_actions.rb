module SinatraMore
  module ComponentActions
    # Injects require statement into target file
    # insert_require('active_record', :path => "test/test_config.rb", :indent => 2)
    # options = { :path => '...', :indent => 2, :after => /.../ }
    def insert_require(*libs)
      options = libs.extract_options!
      options.reverse_merge!(:indent => 0, :after => /require\sgem.*?\n/)
      multiple_gem_require = "%w[#{libs.join(' ')}].each { |gem| require gem }\n"
      req = indent_spaces(options[:indent]) + (libs.size == 1 ? "require '#{libs}'\n" : multiple_gem_require)
      inject_into_file(options[:path], req, :after => options[:after])
    end

    # Returns space characters of given count
    # indent_spaces(2)
    def indent_spaces(count)
      ' ' * count
    end

    # Injects the test class text into the test_config file for setting up the test gen
    # insert_test_suite_setup('...CLASS_NAME...')
    # => inject_into_file("test/test_config.rb", TEST.gsub(/CLASS_NAME/, @class_name), :after => "set :environment, :test\n")
    def insert_test_suite_setup(suite_text, options={})
      options.reverse_merge!(:path => "test/test_config.rb", :after => "set :environment, :test\n")
      inject_into_file(options[:path], suite_text.gsub(/CLASS_NAME/, @class_name), :after => options[:after])
    end

    # Injects the mock library include into the test class in test_config for setting up mock gen
    # insert_mock_library_include('Mocha::API')
    # => inject_into_file("test/test_config.rb", "  include Mocha::API\n", :after => /class.*?\n/)
    def insert_mocking_include(library_name, options={})
      options.reverse_merge!(:indent => 2, :after => /class.*?\n/, :path => "test/test_config.rb")
      include_text = indent_spaces(options[:indent]) + "include #{library_name}\n"
      inject_into_file(options[:path], include_text, :after => options[:after])
    end
  end
end

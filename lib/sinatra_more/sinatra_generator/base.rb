require File.dirname(__FILE__)+'/tests/bacon_test_gen'

module SinatraMore
  class Base < Thor::Group
    include Thor::Actions

    argument :name
    argument :path

    class_option :test, :default => :bacon
    class_option :orm, :default => :sequel
    class_option :script, :default => :jquery
    class_option :template, :default => :haml
    class_option :mock, :default => :rr

    @@available = {
      :mocks => [:rr,:mocha],
      :tests => [:bacon,:shoulda,:rspec],
      :scripts => [:jquery,:prototype,:rightjs],
      :templates => [:haml,:erb],
      :orms => [:sequel,:datamapper,:mongomapper,:activerecord]
    }

    %w[test mock script template orm].each do |comp|
      define_method("include_#{comp}") do
        unless eval("@@available[#{comp.pluralize.to_sym.inspect}]").include? options[comp].to_sym
          raise "Option not supported"
        end
        self.class.send(:include, "SinatraMore::#{options[comp].to_s.capitalize}#{comp.capitalize}Gen".constantize)
      end
    end

    def self.source_root
      File.dirname(__FILE__)
    end

    def build_skeleton
      @root_path = File.join(path,name)
      @class_name = name.classify
      directory("skeleton/",@root_path)
      %w[test orm template mock script].each do |component|
        send("build_#{component}") if respond_to?("build_#{component}")
      end
    end

  end
end

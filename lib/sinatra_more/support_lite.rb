# This is for adding specific methods that are required by sinatra_more if activesupport isn't required

require 'yaml' unless defined?(YAML)

unless String.method_defined?(:titleize) && Hash.method_defined?(:slice)
  require 'active_support/core_ext/kernel'
  require 'active_support/core_ext/array'
  require 'active_support/core_ext/hash'
  require 'active_support/core_ext/module'
  require 'active_support/core_ext/class'
  require 'active_support/deprecation'
  require 'active_support/inflector'
end

unless String.method_defined?(:blank?)
  begin
    require 'active_support/core_ext/object/blank'
  rescue LoadError
    require 'active_support/core_ext/blank'
  end
end
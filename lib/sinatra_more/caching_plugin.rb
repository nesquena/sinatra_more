require File.dirname(__FILE__) + '/support_lite'
Dir[File.dirname(__FILE__) + '/caching_plugin/**/*.rb'].each {|file| load file }

module SinatraMore
  module CachingPlugin
    def self.registered(app)
      app.helpers CachingHelpers
      
      
    end
  end  
end
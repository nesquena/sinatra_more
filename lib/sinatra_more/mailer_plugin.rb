require 'tilt'
require File.dirname(__FILE__) + '/support_lite'
require File.dirname(__FILE__) + '/../../vendor/pony/lib/pony'
Dir[File.dirname(__FILE__) + '/mailer_plugin/**/*.rb'].each { |file| load file }

module SinatraMore
  module MailerPlugin
    def self.registered(app)
      MailerBase::views_path = app.views
    end
  end  
end
require File.dirname(__FILE__) + '/support_lite'
require 'warden' unless defined?(Warden)
load File.dirname(__FILE__) + '/markup_plugin/output_helpers.rb'
Dir[File.dirname(__FILE__) + '/warden_plugin/**/*.rb'].each {|file| load file }

module SinatraMore
  module WardenPlugin
    # This is the basic password strategy for authentication
    class BasicPassword < Warden::Strategies::Base
      def valid?
        username || password
      end

      def authenticate!
        u = User.authenticate(username, password)
        u.nil? ? fail!("Could not log in") : success!(u)
      end

      def username
        params['username'] || params['nickname'] || params['login'] || params['email']
      end

      def password
        params['password'] || params['pass']
      end
    end

    def self.registered(app)
      raise "WardenPlugin::Error - Install warden with 'sudo gem install warden' to use plugin!" unless Warden && Warden::Manager
      app.use Warden::Manager do |manager|
        manager.default_strategies :password
        manager.failure_app = app
      end
      app.helpers SinatraMore::OutputHelpers
      app.helpers SinatraMore::WardenHelpers

      # TODO Improve serializing methods
      Warden::Manager.serialize_into_session{ |user| user.nil? ? nil : user.id }
      Warden::Manager.serialize_from_session{ |id|   id.nil? ? nil : User.find(id) }
      Warden::Strategies.add(:password, BasicPassword)
    end
  end
end

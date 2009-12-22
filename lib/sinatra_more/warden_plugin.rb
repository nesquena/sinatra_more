require File.dirname(__FILE__) + '/support_lite'
require 'warden' unless defined?(Warden)
load File.dirname(__FILE__) + '/markup_plugin/output_helpers.rb'
Dir[File.dirname(__FILE__) + '/warden_plugin/**/*.rb'].each {|file| load file }

module SinatraMore
  module WardenPlugin
    # This is the basic password strategy for authentication
    class PasswordStrategy < Warden::Strategies::Base
      cattr_accessor :user_class

      def valid?
        username || password
      end

      def authenticate!
        raise "Please either define a user class or set SinatraMore::WardenPlugin::PasswordStrategy.user_class" unless user_class
        u = user_class.authenticate(username, password)
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
        manager.default_serializers :session, :cookie
        manager.failure_app = app
        manager.serializers.update(:session) do
          def serialize(user); user.nil? ? nil : user.id; end
          def deserialize(id); id.nil? ? nil : PasswordStrategy.user_class.find(id); end
        end
      end
      app.helpers SinatraMore::OutputHelpers
      app.helpers SinatraMore::WardenHelpers
      Warden::Manager.before_failure { |env,opts| env['REQUEST_METHOD'] = "POST" }
      Warden::Strategies.add(:password, PasswordStrategy)
      PasswordStrategy.user_class = User if defined?(User)
    end
  end
end

require 'sinatra/base'
require 'sinatra_more'
require 'warden'

class User
  attr_accessor :id, :name, :username, :password
  
  def initialize(id, name, username, password)
    self.id, self.name, self.username, self.password = id, name, username, password
  end
  
  def self.find(id)
    return self.john_user if id == self.john_user.id
  end
  
  def self.authenticate(username, password)
    return self.john_user if username == self.john_user.username && password == self.john_user.password
  end
  
  def self.john_user
    @john ||= User.new(21, "John", 'john21', 'secret')
  end
end

class WardenDemo < Sinatra::Base
  use Rack::Session::Cookie
  register SinatraMore::WardenPlugin
  
  configure do
    set :root, File.dirname(__FILE__)
  end
  
  post '/login' do
    authenticate_user!
  end
  
  get '/current_user' do
    "<h1>#{current_user.send(:name)}</h1>"
  end
end
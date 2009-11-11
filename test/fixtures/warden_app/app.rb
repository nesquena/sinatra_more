require 'sinatra/base'
require 'sinatra_more'
require 'warden'

class WardenUser
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
    @john ||= WardenUser.new(21, "John", 'john21', 'secret')
  end
end

class WardenDemo < Sinatra::Base
  use Rack::Session::Cookie
  register SinatraMore::WardenPlugin
  SinatraMore::WardenPlugin::PasswordStrategy.user_class = WardenUser

  configure do
    set :root, File.dirname(__FILE__)
  end

  get '/login' do
    "<h1>Please login!</h1>"
  end

  post '/login' do
    authenticate_user!
  end

  get '/logout' do
    logout_user!
  end

  get '/logged_in' do
    "<h1>logged_in? #{logged_in?}</h1>"
  end

  get '/authenticated' do
    haml :dashboard
  end

  get '/unregistered' do
    haml :dashboard
  end

  get '/must_be_authorized' do
    must_be_authorized!('/login')
    "<h1>Valid Authorized Page</h1>"
  end
  
  post '/unauthenticated/?' do
    status 401
    '<h2>Unauthenticated</h2>'
  end

  get '/current_user' do
    if current_user
      "<h1>#{current_user.name}</h1>"
    else
      "<h2>Not logged in</h2>"
    end
  end
end

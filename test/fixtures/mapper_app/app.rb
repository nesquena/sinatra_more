require 'sinatra/base'
require 'sinatra_more'
require 'haml'

class MapperUser
  attr_accessor :name
  def initialize(name); @name = name; end
end

class MapperDemo < Sinatra::Base
  register SinatraMore::MapperPlugin
  
  configure do
    set :root, File.dirname(__FILE__)
  end
  
  map(:admin, :show).to("/admin/:id/show")
  map(:account).to("/the/accounts/:name/path/:id/end")
  map(:accounts).to("/the/accounts/index/?")
  
  namespace :admin do
    get :show do
      "admin show for #{params[:id]}"
    end
  end
  
  get :account do
    "<h1>the account url for #{params[:name]} and id #{params[:id]}</h1>"
  end
  
  get :accounts do
    "<h1>the accounts index</h1>"
  end
  
  get '/links' do
    haml :index
  end
end
require 'sinatra/base'
require 'sinatra_more'
require 'haml'

class RenderDemo < Sinatra::Base
  register SinatraMore::RenderPlugin
  
  configure do
    set :root, File.dirname(__FILE__)
  end
  
  get '/render_haml' do
    @template = 'haml'
    haml_template 'foo/test'
  end
  
  get '/render_erb' do
    @template = 'erb'
    erb_template 'bar/test'
  end
end

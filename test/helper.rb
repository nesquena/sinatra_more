require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'mocha'
require 'rack/test'
require 'webrat'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'sinatra_more'

class Test::Unit::TestCase
  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers    
  
  Webrat.configure do |config|
    config.mode = :rack
  end
end

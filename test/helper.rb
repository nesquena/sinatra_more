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
  include SinatraMore::OutputHelpers
  include SinatraMore::TagHelpers
  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers

  Webrat.configure do |config|
    config.mode = :rack
  end

  def stop_time_for_test
    time = Time.now
    Time.stubs(:now).returns(time)
    return time
  end

  # assert_has_tag(:h1, :content => "yellow") { "<h1>yellow</h1>" }
  # In this case, block is the html to evaluate
  def assert_has_tag(name, attributes = {}, &block)
    html = block && block.call
    matcher = HaveSelector.new(name, attributes)
    raise "Please specify a block!" if html.blank?
    assert matcher.matches?(html), matcher.failure_message
  end
end

module Webrat
  module Logging
    def logger # :nodoc:
      @logger = nil
    end
  end
end

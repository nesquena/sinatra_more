require 'helper'
# require 'fixtures/caching_app/app'

class TestCachingPlugin < Test::Unit::TestCase
  def app
    CachingDemo.tap { |app| app.set :environment, :test }
  end
end
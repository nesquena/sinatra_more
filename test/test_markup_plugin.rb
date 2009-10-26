require 'helper'
require 'fixtures/markup_app/app'

class TestMarkupPlugin < Test::Unit::TestCase
  include SinatraMore::OutputHelpers
  include SinatraMore::TagHelpers
  
  def app
    MarkupDemo.tap { |app| app.set :environment, :test }
  end
  
  should "work properly by adding tag methods" do
    assert self.respond_to?(:tag)
  end
end
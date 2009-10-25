require 'helper'
require 'fixtures/warden_app/app'

class TestWardenPlugin < Test::Unit::TestCase
  def app
    WardenDemo.tap { |app| app.set :environment, :test }
  end
  
  context 'for authenticate_user! helper' do
    setup do
      visit '/login', :post, :username => 'john21', :password => 'secret'
      visit '/current_user'
    end
    should "return name of logged_in user" do
      assert_have_selector :h1, :content => "John"
    end
  end
end